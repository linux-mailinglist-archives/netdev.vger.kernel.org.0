Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7AD1983D9
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgC3TBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:01:53 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39024 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgC3TBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:01:53 -0400
Received: by mail-lf1-f66.google.com with SMTP id h6so9387916lfp.6;
        Mon, 30 Mar 2020 12:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zlQbnySKJCe92nawFTAdovN2bACt2NgXTueuM9/Cs8I=;
        b=sYsmgd65w/OI8iRzrfFzhtwVKiYgtI8uiehZz5o8i68PiwI1dpJs8pGkddiK0b/Dtf
         KfnE1ahn1UBvXm1fTEtUuIrckN/zwFkLvVUNHc8c9UaKUqr3Evu7mXcLiB7E4lYsCMDD
         DYl7ZnX4WIz+kG3rm3oOsPYskcURWSoeC6ZpFMdt2AgQVdQJ0KedZNg2rI7eZsF8aPYW
         jjSf+jkye4dAWm+nmP0X4RcKpQ8DwwD9ZrNHTC+pCn44jubdmiHIR8xovFVRqMg6aD0b
         WMA4IVS7RO32gUfklcIjQvXl8/cZhVco+otVt03EqVEBoxNrz7mb5v/Zi5N61vq8Lj+W
         dFeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zlQbnySKJCe92nawFTAdovN2bACt2NgXTueuM9/Cs8I=;
        b=htnBAX36pAHGmsljch7GZqL33MO9w/+MXTH5IOcAV5guRxTAXh70b/zibOJ/355RN2
         ZEebtFtPSsBdhapOdNl7wJ96PsGroxISfsFFt4VsvSGCe1XkQN0X94hDtgEkq9YC/mfm
         F0bqUm8LflsyHWEnCKYhh5juNQPJ2J1d4+aLriNTohHXmDQn8cTPJCzt2VzrOey5XTnd
         54V965cOej44lnlOACIrLxDUeRlUkaqIMhk3U3exyxJp8MW3ZrHWCbJfEcyjcmhC2qZz
         PqZ6D2eYX0QsME2Cy6TBkV3IvesAxXyjRIBJKRcE1gf5kwwd6fDmiSV/WflLAbPrNE+f
         s6LA==
X-Gm-Message-State: AGi0PubmfrhmwzTOeffecJzyoDOkmoyHqXn7Mu07WxVz2OSDQOQjQMIw
        pTC4cBAaw8aVhMquJsKsljft9/yHYKx/DiwnbmnNcw==
X-Google-Smtp-Source: APiQypLaiMfjZSaG/BiL9HkDl1KhQoP5oVEFRlVxK7Y/njusPbtG7PElLGs00hm1rX+Mbbe/HTMIKC3BmbuqmGgjsNA=
X-Received: by 2002:ac2:4191:: with SMTP id z17mr8774683lfh.73.1585594911018;
 Mon, 30 Mar 2020 12:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200330160324.15259-1-daniel@iogearbox.net>
In-Reply-To: <20200330160324.15259-1-daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 30 Mar 2020 12:01:39 -0700
Message-ID: <CAADnVQJYbXEgxDDYEgJjgKcTHCKO34wnv5W8KYQE53zJXYvAfg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Fix __reg_bound_offset32 handling
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jann Horn <jannh@google.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 9:03 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Fix for the verifier's __reg_bound_offset32() handling, please see individual
> patches for details.

Applied. Thanks
