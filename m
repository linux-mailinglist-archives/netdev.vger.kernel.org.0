Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37ECC9F751
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 02:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfH1AbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 20:31:06 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:51563 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfH1AbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 20:31:06 -0400
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
        (Authenticated sender: pshelar@ovn.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 675BB200002
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:31:04 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id m62so689710vsc.8
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 17:31:04 -0700 (PDT)
X-Gm-Message-State: APjAAAX4veEvWM9gSqG/Zy4KkoIKYG3lyGB+1jYgyceQvrEqWDdYYHJC
        oYiU+MoBklO7HbT35ib5Uuud+mkOGELqvFnPwjk=
X-Google-Smtp-Source: APXvYqz9H1hncsVc/Pc7JYBHWVCkp+lysQ2v6hQZeTbQHJygnn6GPTj+IguOt5Si1tX7yEyBBz7C9/LKDZx9ar8w8kg=
X-Received: by 2002:a67:eb4e:: with SMTP id x14mr833581vso.103.1566952263084;
 Tue, 27 Aug 2019 17:31:03 -0700 (PDT)
MIME-Version: 1.0
References: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com> <1566917890-22304-2-git-send-email-gvrose8192@gmail.com>
In-Reply-To: <1566917890-22304-2-git-send-email-gvrose8192@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 27 Aug 2019 17:33:13 -0700
X-Gmail-Original-Message-ID: <CAOrHB_AVT7CaLHgS7qLhhneaxSO3VToFKMNZkocUnyVOxtPV5A@mail.gmail.com>
Message-ID: <CAOrHB_AVT7CaLHgS7qLhhneaxSO3VToFKMNZkocUnyVOxtPV5A@mail.gmail.com>
Subject: Re: [PATCH V3 net 2/2] openvswitch: Clear the L4 portion of the key
 for "later" fragments.
To:     Greg Rose <gvrose8192@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>, Justin Pettit <jpettit@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 7:58 AM Greg Rose <gvrose8192@gmail.com> wrote:
>
> From: Justin Pettit <jpettit@ovn.org>
>
> Only the first fragment in a datagram contains the L4 headers.  When the
> Open vSwitch module parses a packet, it always sets the IP protocol
> field in the key, but can only set the L4 fields on the first fragment.
> The original behavior would not clear the L4 portion of the key, so
> garbage values would be sent in the key for "later" fragments.  This
> patch clears the L4 fields in that circumstance to prevent sending those
> garbage values as part of the upcall.
>
> Signed-off-by: Justin Pettit <jpettit@ovn.org>

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
Pravin.
