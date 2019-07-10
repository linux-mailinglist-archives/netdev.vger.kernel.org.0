Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56CE63FA3
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 05:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfGJD2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 23:28:37 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36728 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfGJD2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 23:28:37 -0400
Received: by mail-io1-f67.google.com with SMTP id o9so1632246iom.3;
        Tue, 09 Jul 2019 20:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=y++2NOiqCMguDknkQiXa12j8nNvRVL4zn7Iko7nn4Xo=;
        b=nzV6tzvC1Lxup+L4XiL5KBuvvUZhs13EyZi5NlD/1Mm1kF5KNDsz41aMsiayUp2ydO
         emdAKJBgVFFWECezHXR+lqIXim5GuXqauHo5xip7uhuUCSnrGiVZo9cCpPU6Ty8D7EXI
         JxyvlRqotJwocw5uy3EwJlg5mExhXH72k4GeUaugdvSFe6o0TVuTSeNT3fZjvtDy5RUF
         /K7wsjkqrS2uofL/u8rnyFAiWJ/3G3DjrBXsEivc/FHRsO2plfVaNhNVKVTcwiUSrNcH
         n04pYc/TuSjNvBsVlqSEScV4MMmpYPLTJ5fivnDk8YcFM5XYbqvsVNsiMqAYxqlNWKih
         aEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=y++2NOiqCMguDknkQiXa12j8nNvRVL4zn7Iko7nn4Xo=;
        b=O0/+52XjVxdZR0G/vn6D/DL0+ttd7N7JEAHMGprZ3uwKbrY/dwlUu+2syvG/S38Uo/
         zySmBS3kNhxE5rNRun3cbNaUJfxXGnK714MfSaE36/VM5cwuVDPdGlu+60THhyi39EcJ
         DzXZrxMJHH1mc+vcFKpVwuvM14END208+s4wnQ3LWcfIBkb07ionymga9a4KNDj0v0IF
         mwmc0p1UyiZR+AA7buyuRvcJNeyZJ518hGdb1Y3dg7JQroNtxkAHMg5S96hEvp+clKO/
         b0kBcENbMa8sJXRvp74Xvks8AZsb98WapZdd2uH93gOjRmpJJ1t/qO8Mx+5QACZ4ymYI
         IC7A==
X-Gm-Message-State: APjAAAWvkAb9Tvkc+Slh2ug6lOAQJA4WR0QmfV3UI2QtXy1YO224eYqN
        fP0dk60SuKSbZvVww7rbAL0=
X-Google-Smtp-Source: APXvYqwE0v6A2033SbRiSUeuJdUCGbaIjXvvCprigEquCL7OQhhLESFnMm0OXOd1Gsz2+IqHep6ggg==
X-Received: by 2002:a05:6602:cc:: with SMTP id z12mr10234647ioe.86.1562729316861;
        Tue, 09 Jul 2019 20:28:36 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r7sm569188ioa.71.2019.07.09.20.28.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 20:28:36 -0700 (PDT)
Date:   Tue, 09 Jul 2019 20:28:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d255b58e38e_1b7a2aec940d65b42f@john-XPS-13-9370.notmuch>
In-Reply-To: <20190709192145.473d2d80@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
 <20190708231318.1a721ce8@cakuba.netronome.com>
 <5d24b55e8b868_3b162ae67af425b43e@john-XPS-13-9370.notmuch>
 <20190709170459.387bced6@cakuba.netronome.com>
 <20190709192145.473d2d80@cakuba.netronome.com>
Subject: Re: [bpf PATCH v2 0/6] bpf: sockmap/tls fixes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Tue, 9 Jul 2019 17:04:59 -0700, Jakub Kicinski wrote:
> > On Tue, 09 Jul 2019 08:40:14 -0700, John Fastabend wrote:
> > > Jakub Kicinski wrote:  
> > > > Looks like strparser is not done'd for offload?    
> > > 
> > > Right so if rx_conf != TLS_SW then the hardware needs to do
> > > the strparser functionality.  
> > 
> > Can I just take a stab at fixing the HW part?
> > 
> > Can I rebase this onto net-next?  There are a few patches from net
> > missing in the bpf tree.
> 
> I think I fixed patch 1 for offload, I need to test it a little more
> and I'll send it back to you. In the meantime, let me ask some
> questions about the other two :)

Great thanks. When your ready push it back and I'll retest in
my setup.
