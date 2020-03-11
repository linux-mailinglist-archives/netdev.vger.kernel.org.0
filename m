Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9158180D69
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgCKBRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:17:52 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:44369 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgCKBRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:17:52 -0400
Received: by mail-ot1-f45.google.com with SMTP id v22so253542otq.11;
        Tue, 10 Mar 2020 18:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FIpHicZ3t9iIlvAbQDoq7yMgDqITyaH5TIJrz/BqXnM=;
        b=fw7PTvl2MhJgDakZwvudlq0gxJTnOwVNwCEqEat2rdtdkKmeZD8+70LgewQKpboECD
         Nb3SzqyR78fI5pUOaB/tt0hV5wxYQMqNdPwdQkfksMMg+mFNDPoI6dkjnztOyrwyOZob
         CksHAs3+/gubF1CrA0ec6vzlANwGXOcI0F3vuk0ONUu5dxjN5UsQsUUDJU94B90k1O/s
         SeuH+FQ0eji2Pacvqzg57mMmyh7a7TEmh074TZrbH0H4q3uQ1bO275Gp0HP7+SRwCKM/
         5Vbifz3Lerhj5zs/dWMTpYTiyt5HQKNzn9m388XDl6JjcGXcdfZAuFUaGtiuhzOkuckm
         k68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FIpHicZ3t9iIlvAbQDoq7yMgDqITyaH5TIJrz/BqXnM=;
        b=mfGjEAItK9JUpwbWEZTnpDv+Qo46mF+Z0xuaA5/kYTy1LknYurSH1Qf2EHWu2za1q1
         cVgQo4iaHzTbvOKAXVu4QfafOdq4J6ocfe05MwulwzzHRmoPRhsf/bVqR1h3v0nQK75L
         2tadnNw8oGRdMaVwjBIUDdqIXm5TMR34BRc0XXSKj7gTNbeMvGa/T2RjT8LcdmJ3nir/
         4HlpMNPsoFHGVbeHBcVg9U5fpUOPemoxjmwJpsQQn9OWfk8Y0G2HamE/EOtEhljgshMw
         oovdOvTZ4cB2S265wVd0F0RVFVHq1dB+WE0mUdVVglMiwkMy+BDvv09KNHOAFlCQpPGb
         AWaA==
X-Gm-Message-State: ANhLgQ2ciUBkmHIO5EpItiAGTTBt4gTo9Z3OnHWDnnH8i+6ofliSvkVp
        ACTzMXPPmg/8Iud3Tmhexe7g4N1+DFhFWGfjZJs=
X-Google-Smtp-Source: ADFU+vuhKF1v+vup0kdBVr7A8Vm7Jra+CtZeQ0Wyajafk/bF5zFsN/TFEXuiVxHKa+W73xkLdUkBFs8rj6nK6NrpE34=
X-Received: by 2002:a9d:4702:: with SMTP id a2mr410773otf.319.1583889471514;
 Tue, 10 Mar 2020 18:17:51 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000034513e05a05cfc23@google.com>
In-Reply-To: <00000000000034513e05a05cfc23@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 10 Mar 2020 18:17:40 -0700
Message-ID: <CAM_iQpXLZ1PaG757i1NiQH9q+xuZAzhued0DYEGNH2XtAWZq2A@mail.gmail.com>
Subject: Re: KASAN: invalid-free in tcf_exts_destroy
To:     syzbot <syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/congwang/linux.git tcindex
