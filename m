Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCD31741B8
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 22:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgB1VzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 16:55:16 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:56310 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgB1VzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 16:55:16 -0500
Received: by mail-pj1-f66.google.com with SMTP id a18so1813423pjs.5
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 13:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ebDLfY7TATH8p/YeHbwAw/NPHvKCtewCgBeK+IusRA=;
        b=uIsZceZuqrl8kmFOGM3bjfHkfR3rZ0H1I5PpfVf7CfSfbnHdpXsRx7XZqs+r7iPIbu
         TY4ZWdC8n/DxRmJbmh3R8iQ8+aaFrlg2L4VKXORYShfku7I+rytnYXRqlSPb8A1QX/B+
         2WLpVogWnPLIsjquc07zb9fmO89dCqNqC9HncLU0CVdJGMO4UDtzVvWE7UcK9vQl6/tT
         0GHnK/LriXTYfGOYbk0oPKQ374XWG9fCG61j0aZOWuSNajzBJw7X1zEDt0NLlFhgbMLC
         JYRFyaD9aGHX03pxkCr6Oz3PThQXbVJOADlzvMz2BuOHryxH1uM0GrEwReX9eCU6VhIE
         iM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ebDLfY7TATH8p/YeHbwAw/NPHvKCtewCgBeK+IusRA=;
        b=dUDzWR2BLnv/Wr23BRnznbUI07jVdwulNNFAyMv7pCnxBxmQhy5/GrT4kSeBkpAnfA
         GQMBQ4+cZYGjokaJmVNAQRb0oekH6jRndWlOPt6wmtzfGaq+2kr3uZBESV3VmfoRV0WK
         m26Moqk55CI74myIQkaSHIVadpFIsXtBIb2umxH4FyErT6agPgrjhtm1ilSeNc9mkaL0
         pRtwCM7zDmMEMvuC83LwiCt20of2a0kh///4umb09tccj9OB4Cb4gV/0H1AE/rXtllmj
         T6gCkHoL9eK4Clpx/YIxoFJlFpzLlCQMYY0s2RwZ4ZtFisPxyYSZb44fistfIp+u+NU2
         K/Ng==
X-Gm-Message-State: APjAAAU4JxM+m9Vqy0iOw3j16X9s4a4anUEtvDRX0XnasOjEEZPXKxDk
        6CPLT4/kuBqcHcZPVInCngOpmUNHIv8=
X-Google-Smtp-Source: APXvYqwGFKztoUViWioomwSqYln4W7CcABcnoJu5zCN7fhKwSFOcambFn3daeQzlgGrslOUOY1FX9A==
X-Received: by 2002:a17:90a:da03:: with SMTP id e3mr6900475pjv.57.1582926913743;
        Fri, 28 Feb 2020 13:55:13 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d1sm3782824pfc.3.2020.02.28.13.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 13:55:13 -0800 (PST)
Date:   Fri, 28 Feb 2020 13:55:10 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2 0/2] rdma man pages improvements
Message-ID: <20200228135510.7a9c7e02@hermes.lan>
In-Reply-To: <cover.1582910855.git.aclaudi@redhat.com>
References: <cover.1582910855.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 18:36:23 +0100
Andrea Claudi <aclaudi@redhat.com> wrote:

> - Add missing descriptions for both resource subcomand and filters on
>   the statistic subcommand.
> - Add filter description on the rdma statistic help message
> - Fix some whitespace issue on the rdma statistic man page
> 
> Andrea Claudi (2):
>   man: rdma.8: Add missing resource subcommand description
>   man: rdma-statistic: Add filter description
> 
>  man/man8/rdma-statistic.8 | 16 ++++++++++++----
>  man/man8/rdma.8           |  6 +++++-
>  rdma/stat.c               |  1 +
>  3 files changed, 18 insertions(+), 5 deletions(-)
> 

Looks good, applied
