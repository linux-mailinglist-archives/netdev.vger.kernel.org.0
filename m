Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 838619F753
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 02:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfH1Ab2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 20:31:28 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:36117 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfH1Ab2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 20:31:28 -0400
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
        (Authenticated sender: pshelar@ovn.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id E6A68100003
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:31:26 +0000 (UTC)
Received: by mail-ua1-f50.google.com with SMTP id y7so241893uae.10
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 17:31:26 -0700 (PDT)
X-Gm-Message-State: APjAAAW941Kre1dweQZYBoFcINDrKb9Pv4nJpwvDPAfRiGnG8tOcEM7v
        V1djK/ibxWbGO+YOL64SXeg/J87Ljv770RNaPx0=
X-Google-Smtp-Source: APXvYqyN4KsKsGi0LMz0Pnknqqv3760uf+ptwAl3HfsY6KgP3g/SIVqRaBwJeev4lLTnXPQNDdIchpiTBCtZfFn3DJQ=
X-Received: by 2002:ab0:2a91:: with SMTP id h17mr569558uar.124.1566952285623;
 Tue, 27 Aug 2019 17:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com>
In-Reply-To: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Tue, 27 Aug 2019 17:33:36 -0700
X-Gmail-Original-Message-ID: <CAOrHB_DXXSoe9rjamp_OSxDonsqTADrbV4GdUdct=uq_eOXN-Q@mail.gmail.com>
Message-ID: <CAOrHB_DXXSoe9rjamp_OSxDonsqTADrbV4GdUdct=uq_eOXN-Q@mail.gmail.com>
Subject: Re: [PATCH V3 net 1/2] openvswitch: Properly set L4 keys on "later"
 IP fragments
To:     Greg Rose <gvrose8192@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 7:58 AM Greg Rose <gvrose8192@gmail.com> wrote:
>
> When IP fragments are reassembled before being sent to conntrack, the
> key from the last fragment is used.  Unless there are reordering
> issues, the last fragment received will not contain the L4 ports, so the
> key for the reassembled datagram won't contain them.  This patch updates
> the key once we have a reassembled datagram.
>
> The handle_fragments() function works on L3 headers so we pull the L3/L4
> flow key update code from key_extract into a new function
> 'key_extract_l3l4'.  Then we add a another new function
> ovs_flow_key_update_l3l4() and export it so that it is accessible by
> handle_fragments() for conntrack packet reassembly.
>
> Co-authored by: Justin Pettit <jpettit@ovn.org>
> Signed-off-by: Greg Rose <gvrose8192@gmail.com>
>
Looks good to me.

Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks,
Pravin.
