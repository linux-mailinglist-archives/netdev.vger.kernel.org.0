Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5833339A500
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhFCPww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:52:52 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:34697 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhFCPww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:52:52 -0400
Received: by mail-pl1-f169.google.com with SMTP id u9so3024165plr.1
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 08:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t9qIwqoKqNZvxIpLY7AClj+BTRyFe5r+O4qXXSbVYOo=;
        b=hfjeCrQlegSGKR3qZ0SUozs3xCaJ5pkKpHpPJPyZsFdPJn6IYypTRz+lGE5r/mkuMA
         TozQjyeIArMkim2Rguq/8uNpZLorVsgPVNmY1erK+MkTZiXVfo8/AmnhB5i7OTaAWGxv
         nzAT9avqwf/865+DmyLihWI07egGP9Nd6/Dj2h7kGMhAUY/oJwD45dtwBRDtSBv6EY4j
         raS+iRpvNGdv6w6G4Xt/b0/hSs38TKlQBu7JcYpEL0yj0eGIDUYJn6BuGWVst4GSr+2W
         lVKLy0iS0HhK5uVjxFhLazcbqoRTLke1ZYY2Oty1T1roqUgagTZYt3SDoK9Dc58IJcQI
         pkRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t9qIwqoKqNZvxIpLY7AClj+BTRyFe5r+O4qXXSbVYOo=;
        b=W7coR4i+Mpmx0IiwIFhN7gRuV+LnAEzpTIpn3jd5Gjc2K2Ud9FYoyHCKWBHztLvpF6
         GUk0lQAI7M6RrSeM+njK6eNJASDfVhhyTX48IqLGOJs1h7bwHeQUHyZsxtIAYyrEg7HG
         EeIoAqM+RuCxbOnRbOXIG89ZQjC10UX0bNttmbZ7Y2MUIb8785j0pB7QMn+BianblmPM
         tg/NUZ70ClSJRjeNP/XvLS4qk68UwopHJMwICC+6biv0L+2pQcuLXpiWcqyF6zrwZuEQ
         EJxwYbIx8D0y3fhBhnfYo0gjq+57ZZ4aIddl/Z83TL7dpRJyqychSP78wOO0wkA0SFy/
         WzLg==
X-Gm-Message-State: AOAM530OF5/7qqgux//Sl2VHFA3mfMCNcU+SU7tPTc8Tqf7UUHpXeTej
        fMIWz1P5ChuUPJCtK9GrEWwlUAvEUIULJg==
X-Google-Smtp-Source: ABdhPJwmnER/N/RTJYSsSf3J8mcG5qNdww4Ej9VCZgUtEu/wsViG9aSsm778GK0Pubuxsyw6Czn1Lg==
X-Received: by 2002:a17:902:7587:b029:109:69bd:3eae with SMTP id j7-20020a1709027587b029010969bd3eaemr168209pll.40.1622735407323;
        Thu, 03 Jun 2021 08:50:07 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id 65sm2600038pfu.159.2021.06.03.08.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 08:50:07 -0700 (PDT)
Date:   Thu, 3 Jun 2021 08:49:57 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v2 1/1] police: Add support for json
 output
Message-ID: <20210603084957.7f62c467@hermes.local>
In-Reply-To: <20210603073345.1479732-1-roid@nvidia.com>
References: <20210603073345.1479732-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Jun 2021 10:33:45 +0300
Roi Dayan <roid@nvidia.com> wrote:

>  	if (tb[TCA_POLICE_TBF] == NULL) {
> -		fprintf(f, "[NULL police tbf]");
> +		print_string(PRINT_FP, NULL, "%s", "[NULL police tbf]");
>  		return 0;
>  	}
>  #ifndef STOOPID_8BYTE
>  	if (RTA_PAYLOAD(tb[TCA_POLICE_TBF])  < sizeof(*p)) {
> -		fprintf(f, "[truncated police tbf]");
> +		print_string(PRINT_FP, NULL, "%s", "[truncated police tbf]");

These are errors, and you should just print them to stderr.
That way if program is using JSON they can see the output on stdout;
and look for non-structured errors on stderr.
