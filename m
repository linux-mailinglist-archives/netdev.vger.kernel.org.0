Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB8C2AF8A3
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgKKTC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKKTC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 14:02:26 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9D7C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 11:02:26 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id g7so2919972ilr.12
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 11:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wJUhAVU55DlobEIoNA0apAgzB87x0yOG4RBVQwFKl9U=;
        b=JiqdzJCBytxDnylf4f5YdfkxKDEdWrW+cVoSlIBqFHdwoIh3WK+2lJJJK9vK8r3CpJ
         CXTm2QbJ3wE2LnlgZYIMqfELaA0pcW4zPumjiupOheTAg63gSAzZBzSnt44NPaBkFRRw
         JuEXAXsmjz7UTb2kG1yD/x4fzcwd5XrqQHv/POt8abWG/zS5YGPFj8d9c7I66MHXloUV
         8W+3/Pj0U3GcnuJ19sChH81cy50n8PR2vFN0Su6QQfJNvAxXBg2y5hHXhd8ci6CSKcbP
         IJ+fbmHNBKTlUETvKjVhQnkyL6zOoicZ5eFAV4d0Q/NSbcBC6bXWPshnB44XK5lCnZ65
         TZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wJUhAVU55DlobEIoNA0apAgzB87x0yOG4RBVQwFKl9U=;
        b=YX+TVNRwJCb1ybXSlid3H/QMv7T4V5hs+U8q+5uJyh8Hq8EnBX9XLFbC+Tttuy1AFN
         mvBZFrx1Sepdh2/o1Qh5o6wVbHftdEI22Zy2KkAXb7mF43XRf5aQ8xENynSU0OdNDIBH
         9Ti3+d4pxFY15rHVfXa/b3TLV3dh51Aas8HavcDae0MIEYPAFZUhuavlxSaBhqwHOg3S
         7KUVLa3WMOFzce/0X/uGO3GHSBabm5qgrV9lguscVrMypxoRLOCKUaEvMboOocruxK43
         FrHzMYB/cywKqc12E377gHW6AKXhMWgLVjsVm1sAlqn6DNcIFJw8/BzP6Zj0acH4ZUHj
         6k8g==
X-Gm-Message-State: AOAM53165xWtTsOxFPWTxC6b8v7uqFOh9Hg2qRf+1VJ36QDts5GVLXz0
        39MJaVONwuJKMMtPvQZvVmh3OAu+/d/TNmUl40k=
X-Google-Smtp-Source: ABdhPJzuCxE05/3uyXIW64aRlL+V6nFLpbPvSysQEKc+BmhfnnLhWdbbITwYoQJwWsSmp/RNA8HIc3fqpXPCsK3vibk=
X-Received: by 2002:a92:ba14:: with SMTP id o20mr20430897ili.268.1605121345616;
 Wed, 11 Nov 2020 11:02:25 -0800 (PST)
MIME-Version: 1.0
References: <1a87f1b4.3d6ab.175b592a271.Coremail.leondyj@pku.edu.cn>
In-Reply-To: <1a87f1b4.3d6ab.175b592a271.Coremail.leondyj@pku.edu.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 11 Nov 2020 11:02:14 -0800
Message-ID: <CAM_iQpVzC6PTX8b0cgXO=Pcp_jFCw-UtP__AYyoN7pZLovkqcQ@mail.gmail.com>
Subject: Re: some question about "/sys/class/net/<iface>/operstate"
To:     =?UTF-8?B?5p2c6Iux5p2w?= <leondyj@pku.edu.cn>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 8:32 PM =E6=9D=9C=E8=8B=B1=E6=9D=B0 <leondyj@pku.ed=
u.cn> wrote:
>
> I want to use inotify to monitor /sys/class/net//operstate  to detect sta=
tus of a iface in real time.
> when I ifdown &amp;&amp; ifup eth3, the content of operstate changed, but=
 the file's Modify time didn't change.
> I don't know the reason, is there any file which can be monitored by inot=
ify to get iface status in real time?
> Much appreciation for any advice!

You need to listen to netdev netlink messages for changes like
this. These messages are generated in real-time.

Thanks.
