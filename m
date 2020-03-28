Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415D719663B
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 14:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgC1NEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 09:04:32 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41173 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgC1NEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 09:04:32 -0400
Received: by mail-qk1-f193.google.com with SMTP id q188so13898859qke.8
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 06:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=c9FsYZw+j8qUJiGGl70LuVf0xQZB6yDoobx3XMK0yCo=;
        b=QuugFF+ERGyMYP1pIpE9/p4lHidE/7V/A8wyeLWR9mvEtos9yPpj52RS1mje8YcCW/
         AIpzCe9PoqPPrrQL9CFf/HaU0otl61+Cr71bJaFhCe2VvTltLE43IxAyYqaLejIBYBu7
         R49peHK1UpBMaOcnrcqBrNt3+8R0lJlJRfm4y2U7Yyb3FfEA4+QKH7b5mHGREcjwCz9n
         UpdLuwaakUyUBc+I2gU0YcGPeaeGGxAfDRMsmdMEtaFgPxqBLx5RyLZbjU2F8Usw3Fby
         zSR7vvKZzTonZSkSH1MjV8zt7zncD+Flv31CYuQcEaQ6/NvqKUWZDh7f8fXwfv6Frw15
         Wy5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=c9FsYZw+j8qUJiGGl70LuVf0xQZB6yDoobx3XMK0yCo=;
        b=eT7c82z0exGBEMGn7fRvZtrP0i8W2/fqHYD7bUc2hTxjiheYcTeHc6JdolhZ/8BNS3
         RKTJycgRV/vV3lC3rSCzyKRMcwow7uqdTPR6EE5QFJjSyiKNo1nrBsngbjHhpPpjEXcN
         B7qmKyUQiA6S4juCiFO++mMnqi7W0iJMrqjKZSxkKn8/8Ub+T0yv/riQdgZWCCwYdEM8
         l0R+QfFVbwAzItHZKblXAA0NxGsqWXIeQIRep47Ttwk7bFLriWkachjz5xtXGKq2V5fg
         1G5JUBQNcbvn4/n+zIA44RGrI5IQRIpOVp8J6gspqQu+vVhXwqUJ9wYYDE3A+rtD8VYa
         mmAQ==
X-Gm-Message-State: ANhLgQ3wibDrW2eZrVLD02Wtic+13UQQVtrZIO42zCKBvWtKuU3dsNEp
        5ncG/g6H4EKzjuWfQRsheUu6iO86cvdxTg4RfpHYRQ==
X-Google-Smtp-Source: ADFU+vtzON+IN0UshcC1IDUvlig3jjicZBMB/xIlCfJIE6WCWpY3iw6aJuK0VWxoHNAVMRqslxpTb0hRrTt+dXxzfGM=
X-Received: by 2002:a37:9e05:: with SMTP id h5mr3716801qke.71.1585400670913;
 Sat, 28 Mar 2020 06:04:30 -0700 (PDT)
MIME-Version: 1.0
References: <CANxWus8WiqQZBZF9aWF_wc-57OJcEb-MoPS5zup+JFY_oLwHGA@mail.gmail.com>
 <CAM_iQpUPvcyxoW9=z4pY6rMfeAJNAbh21km4fUTSredm1rP+0Q@mail.gmail.com>
 <CANxWus9HZhN=K5oFH-qSO43vJ39Yn9YhyviNm5DLkWVnkoSeQQ@mail.gmail.com>
 <CAM_iQpWaK9t7patdFaS_BCdckM-nuocv7m1eiGwbO-jdLVNBMw@mail.gmail.com>
 <CANxWus9yWwUq9YKE=d5T-6UutewFO01XFnvn=KHcevUmz27W0A@mail.gmail.com>
 <CAM_iQpW8xSpTQP7+XKORS0zLTWBtPwmD1OsVE9tC2YnhLotU3A@mail.gmail.com>
 <CANxWus-koY-AHzqbdG6DaVaDYj4aWztj8m+8ntYLvEQ0iM_yDw@mail.gmail.com>
 <CANxWus_tPZ-C2KuaY4xpuLVKXriTQv1jvHygc6o0RFcdM4TX2w@mail.gmail.com>
 <CAM_iQpV0g+yUjrzPdzsm=4t7+ZBt8Y=RTwYJdn9RUqFb1aCE1A@mail.gmail.com>
 <CAM_iQpWLK8ZKShdsWNQrbhFa2B9V8e+OSNRQ_06zyNmDToq5ew@mail.gmail.com> <CANxWus8YFkWPELmau=tbTXYa8ezyMsC5M+vLrNPoqbOcrLo0Cg@mail.gmail.com>
In-Reply-To: <CANxWus8YFkWPELmau=tbTXYa8ezyMsC5M+vLrNPoqbOcrLo0Cg@mail.gmail.com>
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Sat, 28 Mar 2020 14:04:19 +0100
Message-ID: <CANxWus9qVhpAr+XJbqmgprkCKFQYkAFHbduPQhU=824YVrq+uw@mail.gmail.com>
Subject: Re: iproute2: tc deletion freezes whole server
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 11:35 AM V=C3=A1clav Zindulka
<vaclav.zindulka@tlapnet.cz> wrote:
>
> Your assumption is not totally wrong. I have added some printks into
> fq_codel_reset() function. Final passes during deletion are processed
> in the if condition you added in the patch - 13706. Yet the rest and
> most of them go through regular routine - 1768074. 1024 is value of i
> in for loop.

Ok, so I went through the kernel source a little bit. I've found out
that dev_deactivate is called only for interfaces that are up. My bad
I forgot that after deactivation of my daemon ifb interfaces are set
to down. Nevertheless after setting it up and doing perf record on
ifb0 numbers are much lower anyway. 13706 exits through your condition
added in patch. 41118 regular exits. I've uploaded perf report here
https://github.com/zvalcav/tc-kernel/tree/master/20200328

I've also tried this on metallic interface on different server which
has a link on it. There were 39651 patch exits. And 286412 regular
exits. It is more than ifb interface, yet it is way less than sfp+
interface and behaves correctly.

BTW sorry for previous missformated mail. I was trying to put it
inside perf report for better visibility.
