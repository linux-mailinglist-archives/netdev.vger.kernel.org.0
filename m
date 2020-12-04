Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174642CF307
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbgLDRUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729333AbgLDRUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:20:54 -0500
Date:   Fri, 4 Dec 2020 09:20:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607102413;
        bh=pzcWxuqeocDMX8WT2QK/0XUN9oXEedWRCY80VJcpX+4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=kRt5IDOYT9WJVdTCrLiiAFimHg7gsj3CIdC4psJn3zPcNonotq/DoCZKJHpirgbsu
         tQlOjKCIq8VjFjqOeJm+Mti2qMlaEjKrOlYy9kviNtmlH7SkXsXbAHNFOyOs4hZNKr
         OaNnSVhpMOhc/VJ4zY6aZBxcKGhacbPZmuPQkN9zTr0g2DkWo294GTbzeuZjJuIgEu
         sn4kBMe1dYA3bH1TXNIt9E8qJE/7wUCw3dIralsQELTQxhvY/8wEnE4ZvefQvYhqtt
         y2VrFXlC0xeCICEZRu7xqemwlxmCe19RTCCy3AJRVwp6TxPYE/jZ+i3cOKlF1NhNjj
         qLTr4xVZnWfdA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     alardam@gmail.com
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org, toke@redhat.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 0/5] New netdev feature flags for XDP
Message-ID: <20201204092012.720b53bf@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204102901.109709-1-marekx.majtyka@intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 11:28:56 +0100 alardam@gmail.com wrote:
>  * Extend ethtool netlink interface in order to get access to the XDP
>    bitmap (XDP_PROPERTIES_GET). [Toke]

That's a good direction, but I don't see why XDP caps belong in ethtool
at all? We use rtnetlink to manage the progs...
