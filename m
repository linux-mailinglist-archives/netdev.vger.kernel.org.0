Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E107948A5E7
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 03:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiAKCy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 21:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiAKCy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 21:54:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E125C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 18:54:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BA7AB8181E
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 02:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC906C36AE5;
        Tue, 11 Jan 2022 02:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641869696;
        bh=MRM+pU4OceT5fwAw4kRjtN2iC9kX+RRZ491gwEZlBCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y8jLAzlpciFyN+Xex6hZoshcQt3V650akUznUgx94WRGSup/esXkzP9+s+spO40vx
         ugMPAAdDvY4kdVDKtdG6dCjQbRiv2NVkdYjvpyh1YrXNBByMBrV+fsBfwqnknBH9bH
         NNMbgxdA6ZL4CPOC0jrUCRyUvTONK//EW3qZTaO5OAwM6njqI3s499PjKDONb2EUDX
         o8fNStlXOSodNcBNEO2r0ORmf0Q5dWUa7BXBNKPviL/qOsoC5AbNgnKSUT6URApvh2
         unHB/dhqrUEpXfEBkiymkVNZ3kc4LvkkE+74Ga48BF5JIjw9ry/hL+QA6hdh2KKxCx
         dsEQnH5cTX0pw==
Date:   Mon, 10 Jan 2022 18:54:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next] Revert "net: vertexcom: default to disabled on
 kbuild"
Message-ID: <20220110185454.5d75aed9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110205246.66298-1-saeed@kernel.org>
References: <20220110205246.66298-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 12:52:46 -0800 Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This reverts commit 6bf950a8ff72920340dfdec93c18bd3f5f35de6a.
> 
> To align with other vendors, NET_VENDOR configs are supposed to be ON by
> default, while their drivers should default to OFF.

Still planning to rework everything to default to 'n' in net-next later
or did you change your mind? :)
