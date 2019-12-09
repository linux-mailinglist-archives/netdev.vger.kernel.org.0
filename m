Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035BF117826
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 22:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfLIVPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 16:15:39 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:37136 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfLIVPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 16:15:39 -0500
Received: by mail-il1-f193.google.com with SMTP id t9so14106581iln.4
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 13:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LG/614BqKYeqqzAMuAmVs1XZZYF0k1xuurp2HXiCCmY=;
        b=A9Stev5AqloQC1ZtkUVGdq1AP5/fTv2T3N7Xi4NHhqF1zHE7T4Q2XZfauwQ9I71iF6
         AwQBJiBS7lEI16cRnzmpgw6z5pgvGu7XV91StpMMLN4bDmn4u2nNc+1uF3CHYMA+0EYH
         pX5iK+1xGouBTNKH8TYrgYGx58J2PbWJqx0n8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LG/614BqKYeqqzAMuAmVs1XZZYF0k1xuurp2HXiCCmY=;
        b=jBK992hP1Xr9rpd5JAWYN3q3/QbTuP3NfxIBkMLjRMGltiwaw/SUYZCMo6Sf+lUGUb
         f5xf9GXw3VaYQxNNiz5RtxDF1VKBCwUNqFTI6aSuLdHmc7cPLsi5ukmFs1P9y+I2cBJW
         STJCMIIFtHahNYmE/0wmUygDUrL+Ed0JyDIVzoHaTjwIbQnnlCc7ljAiqykoT54AR8kz
         BbUDsef1oJ9JbkdAhO8NXhemt+gQn4hz8fD0Klk3gNWUlxv8ZeQVAW8ZeHzZJbpjYQ7Y
         4+42fIA1VocHBVAKPkLkNN5BEcs+E+lYeNUCVNIJFMkVB4p6GfRz+qsjzUIvPqxgJHLi
         F1pA==
X-Gm-Message-State: APjAAAXfoojBgw3ZMf9AXkTQN7fu7M1vMxHuyfz09OW/xrW2HX9hH84f
        mfzyBQUFCLLvov8Zs5W04uCY75bnq3bQAnWWv4xC1g==
X-Google-Smtp-Source: APXvYqzh3UZWMUWlmFjctjV2C7aY8p4vEvt7LDAOemPKOAaaoVKi0COose4couisqD9FDRyrjewRb57JFJeMDI0UDEs=
X-Received: by 2002:a92:1b41:: with SMTP id b62mr30148546ilb.251.1575926138783;
 Mon, 09 Dec 2019 13:15:38 -0800 (PST)
MIME-Version: 1.0
References: <20191209173136.29615-1-bjorn.topel@gmail.com> <20191209173136.29615-4-bjorn.topel@gmail.com>
In-Reply-To: <20191209173136.29615-4-bjorn.topel@gmail.com>
From:   Luke Nelson <lukenels@cs.washington.edu>
Date:   Mon, 9 Dec 2019 13:15:16 -0800
Message-ID: <CADasFoA5iMv0Atakw_Jr7XP__K+--a735Qb2U-eNfJEzCXQRNQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/8] riscv, bpf: add support for far jumps and exits
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 9:32 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> This commit add support for far (offset > 21b) jumps and exits.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>

Similar to the other patch for far branching, we also used our tool
to formally verify this patch for far jumps:

https://github.com/uw-unsat/bpf-jit-verif/tree/far-jump-review


Reviewed-by: Luke Nelson <lukenels@cs.washington.edu>
Cc: Xi Wang <xi.wang@gmail.com>
