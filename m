Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8ACD165F9
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 16:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfEGOpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 10:45:36 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:35382 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGOpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 10:45:36 -0400
Received: by mail-io1-f43.google.com with SMTP id p2so3201324iol.2
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 07:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=03m+IqSSMpUgpmxUJgYS5LtfBd6i3iQjyiGLSsQrZQg=;
        b=k6hsrKwl5gaOijyZeA+RYuD96ExIWNx/Vf5gpGzHyEfHWPFo9VwG8p12UQDoahjO00
         gPJ+uOe2FGuyYBDvtDReZByUz+pNE7/L6heKs6jc9eXuulZG2k4QHUxWgHF0uHmWUXcf
         CjXakYZhT6amC/v6A9LhLlgwU+H0yNh+0nYgsgOGLIOCds484VvUs26iKU7kjE0FNY/I
         0Xgpyzz7WrQ8ZI9gkdKFrieI9v1FXrOJNZG76jG9pczW4roM/F9NavE3/W73l/8VrjN+
         lTldERj1gx6xhuwSleExzxKejh+QcDCtii2MPK27surlPx7Tf8zaOsmxK29P6TyfFqtH
         yPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=03m+IqSSMpUgpmxUJgYS5LtfBd6i3iQjyiGLSsQrZQg=;
        b=bif5SU9EOHum0frVQJagQXiZV7hmNvfp/PI5VVDmkT7kIgDwzhPFxlAv7vKkroG0bq
         mLYrJNaLgrENKc0F8NhL1Vicj+SpKGZyuAKsNyUEzJetwqq31zT1ijKYtoDuILzK9HBI
         i6rApcISoUPyGj7a8cPKRw867SI2k+Z8jGm7vNI+9gfbIEp3jiOq7ZhTEQlFO1fYL77+
         jTJA1wVmclP7STj4tOic1v41O/o4MjWEqYQAN7HCibgWWKTl+Oc44xZuppfhpjk863La
         WhXXqnJSM8igMvASuQaPEmSuobMSGQE5Kanh48IXAvFHmPuVHnSeQOcKfgCw/YTJAVUk
         Crww==
X-Gm-Message-State: APjAAAWzm4LS8dHhMg4ydOBJtS+97s/iJZ6N0O41595/EIXBc7PPet1s
        U5PsYA9Vv32W1C+PsVvDqh4=
X-Google-Smtp-Source: APXvYqycqxlL7DxpjtBXHFMFf/WjC13hbE0SjpOBnCt2K3LNTypBeyASNQFH2vOzGAkcskCHf2vSQQ==
X-Received: by 2002:a6b:e311:: with SMTP id u17mr21157208ioc.257.1557240335575;
        Tue, 07 May 2019 07:45:35 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d195sm6724836itc.21.2019.05.07.07.45.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 07:45:34 -0700 (PDT)
Date:   Tue, 07 May 2019 07:45:26 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andre Tomt <andre@tomt.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "Steinar H. Gunderson" <steinar+kernel@gunderson.no>,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5cd19a06c0ec1_7e362b112aa185b8da@john-XPS-13-9360.notmuch>
In-Reply-To: <a69bb5f9-45d2-354e-0422-e3d37d4e427d@tomt.net>
References: <20190413153435.73ecztpnbivrckvj@sesse.net>
 <4cdfca7f-bee0-56f5-e512-8ad2e4e6dfcf@tomt.net>
 <f832cd50-50c5-027c-51db-8a3a3ded4563@gmail.com>
 <a69bb5f9-45d2-354e-0422-e3d37d4e427d@tomt.net>
Subject: Re: kTLS broken somewhere between 4.18 and 5.0
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andre Tomt wrote:
> On 14.04.2019 22:40, John Fastabend wrote:
> > On 4/13/19 6:56 PM, Andre Tomt wrote:
> >> On 13.04.2019 17:34, Steinar H. Gunderson wrote:
> >>> Hi,
> >>>
> >>> I've been using kTLS for a while, with my video reflector Cubemap
> >>> (https://git.sesse.net/?p=cubemap). After I upgraded my server from
> >>> 4.18.11 to 5.0.6, seemingly I've started seeing corruption. The data sent
> >>> with send() (HTTP headers, HLS playlists) appears to be fine, but sendfile()
> >>> (actual video data, from a file on tmpfs) is not; after ~20 kB of data
> >>> (19626 in one test here), the data appears to be randomly corrupted. Diffing
> >>> non-TLS (good) and TLS (bad) video data:

[...]

> Hi John
> 
> Have you had any luck tracking this down?
> 
> Just gave net.git a spin and it is still serving up corrupted data when 
> ktls is active and using sendfile.  FWIW I only tested without ktls 
> offload capable hardware (ie in software mode) and no bpf. Same sendfile 
> usage on a non-ktls socket works fine.

Hi Andre, I should have a series to address this in the next few days. I
still need to resolve a couple corner cases. Hopefully, by next week we
can get bpf tree working for this case.

Thanks,
John
