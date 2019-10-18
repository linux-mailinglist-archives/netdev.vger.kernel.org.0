Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9A5DCC15
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502946AbfJRQ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:58:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34458 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392929AbfJRQ6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:58:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so1878035wrr.1
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/GrgSHL1RtnkvHxsk5efyWeUibNpgEs4IkA4bpfivaY=;
        b=gMMEHocUW2ZhK++QNw98p2fgTrbKBIkXo5abTLGRo4pVwkdp93DH3QWWAMh7KSFS1x
         l/fNxinD7gzb1x1QMGCalhRleCeLkWAXkjG+SL/MNyE1BpitWH4v/hHdWrpMzGxUb13m
         jCQSx2kmAaPcf2+RUGy4z8v/ZriD43SmopiuMrRZ6a1VocB3q8UWwlimGQRm0d+kLG1B
         Ph7JkmjJTdb1GLAKbBxZpJFTJbKT0CZCp8NhVaa7farPs9DNJjzo0Bz9wTP7JuqzDNTn
         NaSH+3RQAZISigkbl82YkMVfU6UXbOnXk2DR/iZbSeM9ZvVmDejjLG3tkzvjX+kkyUJ1
         giiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/GrgSHL1RtnkvHxsk5efyWeUibNpgEs4IkA4bpfivaY=;
        b=iRa7V7k9xpkb2mz8o34SnTjnU3dhAMg84/y2KQ506VpDw5yIA02NZ9LVukKo2lfjPN
         7y40V0JxaeFgU2kjvnc2sDq2GqeXPiH8x1b0MEQFuDbyzppdl8fOhiMBRMlcbgZoBrxL
         2ChFjTnlNZcfNjNDEnLBADnIDNwgvsUfLKYOKXVgziIyRAhQ2fZALNA8JFnjodfL8xez
         J2dVsUiGkECisStFEDy6MjVakwN6RxK1Q0h8cEvW7vX27nUGVnJvfcspmrWI57CSegAi
         dje2qBaXpHLIvoWnw8nptjZ72rcrSkWfmiUz4gmB347WNRtTr6g8z1YNrcmV66djeYR3
         /pUw==
X-Gm-Message-State: APjAAAWthPBVzwA2myBl/W08GdMAKfAYk/Vkf/lCvAgKGeraoMWbRRda
        BWEdi4Vai8QJrx9W6Tg6kDOPeQ==
X-Google-Smtp-Source: APXvYqzn2P3YPpXF2XZ759RIRAwpOS5OyxoRobRAjJfOilyrORWPeQHgVG5OBDbqcRregIW4Rc7C9A==
X-Received: by 2002:a5d:4b09:: with SMTP id v9mr8306526wrq.127.1571417923031;
        Fri, 18 Oct 2019 09:58:43 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id u68sm7351424wmu.12.2019.10.18.09.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 09:58:42 -0700 (PDT)
Date:   Fri, 18 Oct 2019 18:58:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, andrew@lunn.ch, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191018165842.GG2185@nanopsycho>
References: <20191018160726.18901-1-jiri@resnulli.us>
 <20191018093322.0a79b622@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018093322.0a79b622@hermes.lan>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 18, 2019 at 06:33:22PM CEST, stephen@networkplumber.org wrote:
>On Fri, 18 Oct 2019 18:07:26 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> +static bool devlink_param_valid_name(const char *name)
>> +{
>> +	int len = strlen(name);
>> +	int i;
>> +
>> +	/* Name can contain lowercase characters or digits.
>> +	 * Underscores are also allowed, but not at the beginning
>> +	 * or end of the name and not more than one in a row.
>> +	 */
>> +
>> +	for (i = 0; i < len; i++) {
>
>Very minor stuff.
>   1. since strlen technically returns size_t why not make both i and len type size_t
>   2. no blank line after comment and before loop?

Ok.

