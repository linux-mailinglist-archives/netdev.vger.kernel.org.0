Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31E54ADD0D
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381158AbiBHPj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381148AbiBHPj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:39:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6B1C06174F;
        Tue,  8 Feb 2022 07:39:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EE32B81BB1;
        Tue,  8 Feb 2022 15:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D9FC004E1;
        Tue,  8 Feb 2022 15:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644334793;
        bh=YLLU/DtyVxRZriQbWwGBNql6tFY/aerdE5OCyjhaS78=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bO31Fak9Hf3WZ5UQTyqE7/Ro2O2Fnp8ckEt4LREUpQ72xg3yLY9ZydXIBScB0BgAV
         +HsYHQFAhyX/TkUTnTAaVQwibMsZEGg5d46ZjPz79GWjPmvbtwMGJX1BnnFAPUS4X3
         EgmMHQEK7W5N2KRWvavy8XHA5Hvr0FNkgrYGEJjggXVrLlb7lxDNezfEK+Wjs1sS8e
         C8BbooPPKP349SVMc8hVCQ2Zp/geMj9uxfRlLuE2YZYzcqzgdWYebNqxM1xqKJoiZq
         F/rzQisxfN0ivna31tzDGPLdTud3BSONZIGec6aF8lPErPnBz9RhfXGbEpKXbGVL/C
         Lga2BQ2c6xL8A==
Date:   Tue, 8 Feb 2022 07:39:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Melnichenko <andrew@daynix.com>
Cc:     Yuri Benditovich <yuri.benditovich@daynix.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Yan Vugenfirer <yan@daynix.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [RFC PATCH 0/5] TUN/VirtioNet USO features support.
Message-ID: <20220208073951.61e65d36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CABcq3pE43rYojwUCAmpW-FKv5=ABcS47B944Y-3kDqr-PeqLwQ@mail.gmail.com>
References: <20220125084702.3636253-1-andrew@daynix.com>
        <1643183537.4001389-1-xuanzhuo@linux.alibaba.com>
        <CAOEp5OcwLiLZuVOAxx+pt6uztP-cGTgqsUSQj7N7HKTZgmyN3w@mail.gmail.com>
        <CABcq3pE43rYojwUCAmpW-FKv5=ABcS47B944Y-3kDqr-PeqLwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Feb 2022 15:09:21 +0200 Andrew Melnichenko wrote:
> Hi people,
> Can you please review this series?

Adding Willem, he might be interested.
