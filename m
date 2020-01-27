Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42A914A8BC
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 18:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgA0RLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 12:11:35 -0500
Received: from mga12.intel.com ([192.55.52.136]:37364 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgA0RLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 12:11:35 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jan 2020 09:11:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,370,1574150400"; 
   d="scan'208";a="401386783"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 27 Jan 2020 09:11:32 -0800
Date:   Mon, 27 Jan 2020 11:02:53 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, bjorn.topel@intel.com, songliubraving@fb.com,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/3] bpf: xdp, virtio_net use access ptr
 macro for xdp enable check
Message-ID: <20200127100253.GA36124@ranger.igk.intel.com>
References: <1580084042-11598-1-git-send-email-john.fastabend@gmail.com>
 <1580084042-11598-3-git-send-email-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580084042-11598-3-git-send-email-john.fastabend@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 04:14:01PM -0800, John Fastabend wrote:
> virtio_net currently relies on rcu critical section to access the xdp
> program in its xdp_xmit handler. However, the pointer to the xdp program
> is only used to do a NULL pointer comparison to determine if xdp is
> enabled or not.
> 
> Use rcu_access_pointer() instead of rcu_dereference() to reflect this.
> Then later when we drop rcu_read critical section virtio_net will not
> need in special handling.
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
