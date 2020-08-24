Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419E0250B0E
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 23:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHXVon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 17:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHXVom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 17:44:42 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B7AC061574;
        Mon, 24 Aug 2020 14:44:41 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id 12so5280512lfb.11;
        Mon, 24 Aug 2020 14:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TdTPQNZpnKf78FVYri0YP31zJnbvLBKjS32AlT/iKJU=;
        b=BVf76X/0z5/rDTYQi3SxYSOlh6YsECZPoUmRX5rtNz9SvQK1N8yKIxxsjp9m2nBbPV
         aY/GNAGc6I3WZQKdOimwIFt8OcQ/aWgpyw+Wd2L1m5hL0ebyB6WK/2tIN70FoI/HYuvf
         1XhAsOkdFjectBneXZHOnJa7JyR0uN2KjaUs83a/lYwKGo8zvKO+2qhcMZOFzP/BOKQQ
         Yl+ae8USR8ss3xt9I04FX5Jaerv9LH1cfgTRSQPIgkG03SDmeZBG7Yv3/4X4ACvnxnsJ
         5YG7vlNV45pgF0tMzC+3uH/8rSnO9kLbLLdjfgSvm98AKLkCWLY/ImVqmAvoL3Bhr0ja
         e0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TdTPQNZpnKf78FVYri0YP31zJnbvLBKjS32AlT/iKJU=;
        b=DKYNsG1y1rAEqu0Wdrol62kP1l9DopoqniaklfNuJ8iEkIcWQ+rCHgNppFtFvi1ITm
         61TIO7h2A+US1iVBSHmg3NbKsBq/Ldn50kwvVx97ERb1JhnGvRPPHhW7vxz+jt+C0d02
         NpuF2XjVKx1W/98K2jGDDYim7Y4Z0INtr2+7BQdDQTV9qU8Gm4jd3fByZ+NfaD6615s7
         rn1qq+Hci8/DUKIgS6NWJzx+LOwLTw/sDQzqukKJOq1kTUtjbe+QhhyWWRSlJ/3d3XCg
         8evckH5TcBy8ZAF1wecmGTENg0Ixn52dEifYSUdQpCkpTXIoNJ8/8ts9efoJUfrQrIg0
         KuDw==
X-Gm-Message-State: AOAM531actNuDL2OvZL+6Z7IMWrHqr6u6T5QQ+7tFlXQwLjDMMkvBZKf
        OvsQP4g26QskYX/KPyjt0IouIGyu4IgILifRno8=
X-Google-Smtp-Source: ABdhPJwCI8wZoJHux1MLa9VCBOqaU+OUSir8cfDbXeBz1WxcArhOLQhozg9Kfn9JQN7d9r8IYHYTD1L48jbEtBY+HT8=
X-Received: by 2002:a19:c20d:: with SMTP id l13mr2031571lfc.157.1598305480290;
 Mon, 24 Aug 2020 14:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200821052817.46887-1-Jianlin.Lv@arm.com> <2b3ed0fe-5be3-05a4-4db0-d0039709e488@fb.com>
In-Reply-To: <2b3ed0fe-5be3-05a4-4db0-d0039709e488@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Aug 2020 14:44:28 -0700
Message-ID: <CAADnVQ+tJkfr1LtzHC8F-A6WLpQHiFts1fmDcmyQ5qWiUrO_aQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] docs: correct subject prefix and update LLVM info
To:     Yonghong Song <yhs@fb.com>
Cc:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, Song.Zhu@arm.com,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 11:23 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/20/20 10:28 PM, Jianlin Lv wrote:
> > bpf_devel_QA.rst:152 The subject prefix information is not accurate, it
> > should be 'PATCH bpf-next v2'
> >
> > Also update LLVM version info and add information about
> > =E2=80=98-DLLVM_TARGETS_TO_BUILD=E2=80=99 to prompt the developer to bu=
ild the desired
> > target.
> >
> > Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
