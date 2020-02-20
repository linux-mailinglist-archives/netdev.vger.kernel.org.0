Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14104165E62
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 14:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgBTNLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 08:11:43 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:58540 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727931AbgBTNLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 08:11:43 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j4lc7-0004yD-4x; Thu, 20 Feb 2020 14:11:35 +0100
Date:   Thu, 20 Feb 2020 14:11:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     rkir@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, rammuthiah@google.com,
        adelva@google.com, lfy@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: disable BRIDGE_NETFILTER by default
Message-ID: <20200220131135.GM19559@breakpoint.cc>
References: <20200219214006.175275-1-rkir@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219214006.175275-1-rkir@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rkir@google.com <rkir@google.com> wrote:
> From: Roman Kiryanov <rkir@google.com>
> 
> The description says 'If unsure, say N.' but
> the module is built as M by default (once
> the dependencies are satisfied).

Acked-by: Florian Westphal <fw@strlen.de>
