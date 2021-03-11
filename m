Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8159336858
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhCKAGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:06:30 -0500
Received: from smtp4.emailarray.com ([65.39.216.22]:39396 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhCKAGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 19:06:08 -0500
Received: (qmail 62062 invoked by uid 89); 11 Mar 2021 00:06:07 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 11 Mar 2021 00:06:07 -0000
Date:   Wed, 10 Mar 2021 16:06:05 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, andrii@kernel.org,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maximmi@nvidia.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 2/2] libbpf: xsk: move barriers from
 libbpf_util.h to xsk.h
Message-ID: <20210311000605.tuo7rg4b7keo76iy@bsd-mbp.dhcp.thefacebook.com>
References: <20210310080929.641212-1-bjorn.topel@gmail.com>
 <20210310080929.641212-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210310080929.641212-3-bjorn.topel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 09:09:29AM +0100, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The only user of libbpf_util.h is xsk.h. Move the barriers to xsk.h,
> and remove libbpf_util.h. The barriers are used as an implementation
> detail, and should not be considered part of the stable API.

Does that mean that anything else which uses the same type of
shared rings (bpf ringbuffer, io_uring, zctap) have to implement
the same primitives that xsk.h has?
-- 
Jonathan
