Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1525D192B51
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgCYOij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:38:39 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44033 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbgCYOij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 10:38:39 -0400
Received: by mail-qk1-f196.google.com with SMTP id j4so2700940qkc.11
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 07:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U51UPV7zMiOvaN9/pNCFSNDzmUSo2QQcK4hWXxfWQac=;
        b=rTMOQ5CwamJV7YX5HUqLlBTz+oIM2WCE588UqKx9PtBZkX9QXJl0/cjgbycOSCz/RJ
         ai1uSmp3lMazoJD/+PKj3GKeTQkUvCHF2BX597V6A+7/eWjvPMPPe/Djn1ABlp5SJdYd
         LPqAImazbBSQw0gX/rhjgc2eekJzuJu+2X85NK2jhMv+lsDIWP+1Ab7On4OqOFbneHqy
         4p9qXpAWOOR4bhkpuxPbB4lQ3ZjuALhJ6vGTaNX6LgwiYLn+5kv3boLt6crRa2U3/f03
         A1mltDHvuJFYlzpzY6CLCECvtwPhBfbve9DFgwDD+2a1gmrvFThOpXD/cjClvbQRrO2X
         J1vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U51UPV7zMiOvaN9/pNCFSNDzmUSo2QQcK4hWXxfWQac=;
        b=dxrxcHZE4bVmnKhe8KJ+6vS1Rc5nmQcjJVLdZ0XKJL7pH5Yl2RlPy2zY8KldWyCAOX
         WHN8Yzqvpxs2OZjtKIY9FlMJnz/1IqH41gj1xLUJAk39wOab42n87RWXTc1BCsscF/Nt
         7slR5+HMgQjmTMbwqR3GvWzq9MH+HvalCp07d/WlzJ98MIWzq2ULWFowvuA3HQam/bj3
         bzBMQ+b4WtBvSDZgqG9ldgYktlvR8lyrQV7lHCHfSx0gy69qvNLfak9iWljFENkequpN
         eP9Cxa1qRKsFI1/A/MHj4gYYeAkDNFozZiJcylrz8lXdft6zcq3sJq2yDo8FAPBAAzes
         ozAg==
X-Gm-Message-State: ANhLgQ2WwtN+N8zItD47vL6TVCUtM99I26QakR4VnQjOv2RNrcF9sOU2
        iYBauH5lxYxqln2IB179//iK9Tcz
X-Google-Smtp-Source: ADFU+vtflNO/m+Goyyg+FTpOySDeyLxqDUsOk5HPq0uFjEG59w6deAGtswxQK84NTich9rjxDSlHYw==
X-Received: by 2002:a37:ae04:: with SMTP id x4mr3156672qke.278.1585147117349;
        Wed, 25 Mar 2020 07:38:37 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id j6sm4421030qti.25.2020.03.25.07.38.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 07:38:36 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id 11so1248606ybj.11
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 07:38:36 -0700 (PDT)
X-Received: by 2002:a25:1042:: with SMTP id 63mr5888502ybq.165.1585147115668;
 Wed, 25 Mar 2020 07:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200325140845.11840-1-yang_y_yi@163.com>
In-Reply-To: <20200325140845.11840-1-yang_y_yi@163.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 25 Mar 2020 10:37:59 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf5U_ndpmBisjqLMihx0q+wCrqndDAUT1vF3=1DXJnumw@mail.gmail.com>
Message-ID: <CA+FuTSf5U_ndpmBisjqLMihx0q+wCrqndDAUT1vF3=1DXJnumw@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: fix TPACKET_V3 performance issue in
 case of TSO
To:     yang_y_yi@163.com
Cc:     Network Development <netdev@vger.kernel.org>, u9012063@gmail.com,
        yangyi01@inspur.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 10:10 AM <yang_y_yi@163.com> wrote:
>
> From: Yi Yang <yangyi01@inspur.com>
>
> TPACKET_V3 performance is very very bad in case of TSO, it is even
> worse than non-TSO case. For Linux kernels which set CONFIG_HZ to
> 1000, req.tp_retire_blk_tov = 1 can help improve it a bit, but some
> Linux distributions set CONFIG_HZ to 250, so req.tp_retire_blk_tov = 1
> actually means req.tp_retire_blk_tov = 4, it won't have any help.
>
> This fix patch can fix the aforementioned performance issue, it can
> boost the performance from 3.05Gbps to 16.9Gbps, a very huge
> improvement. It will retire current block as early as possible in
> case of TSO in order that userspace application can consume it
> in time.
>
> Signed-off-by: Yi Yang <yangyi01@inspur.com>

I'm not convinced that special casing TSO packets is the right solution here.

We should consider converting TPACKET_V3 to hrtimer and allow usec
resolution block timer.

Would that solve your issue?
