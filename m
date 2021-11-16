Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB204534D9
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbhKPPFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237838AbhKPPEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 10:04:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 888DE6103B;
        Tue, 16 Nov 2021 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637074877;
        bh=LqB2FZi1hYy/jUnS60Fo764HoWR/iviShH6TETnclmg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fZ2aYXcggYDSpCBHi2pG4mDn61AUh+whpdpLJjRoGTXrme0bln89pk0xOO5bIEvOV
         dM43w/IfJyQLSy4kUaHrqO2RxmTKHEr2y1p1B1bOFAhNzupNf93ALVtLeYaJJXBN4z
         VTropCk357nD5IcfY6XJjR13mRfrchwwFC3y8oeN0XSKyxoSpSjwcH/z+0q4sO+Q62
         U3KNtrFh94fdTvfkCO60dJ1UYwbVILrhP0/MNdQg/tlgYuGQef36HOvlSD1f5AbJY2
         VeDlIDvWT0fz8oHjfnMT1Nw0/oKXE46ivZhkiJoxiVy0SQj1G+fv0vJXMM7wYGTEwl
         ElWFbEm4B64vw==
Date:   Tue, 16 Nov 2021 07:01:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v18 bpf-next 13/23] bpf: add multi-buffer support to xdp
 copy helpers
Message-ID: <20211116070115.5d9cdc81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bc81f5d195053581e7ab4260575091e556e3f46e.1637013639.git.lorenzo@kernel.org>
References: <cover.1637013639.git.lorenzo@kernel.org>
        <bc81f5d195053581e7ab4260575091e556e3f46e.1637013639.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 23:33:07 +0100 Lorenzo Bianconi wrote:
> From: Eelco Chaudron <echaudro@redhat.com>
> 
> This patch adds support for multi-buffer for the following helpers:
>   - bpf_xdp_output()
>   - bpf_perf_event_output()
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jakub Kicinski <kuba@kernel.org>
