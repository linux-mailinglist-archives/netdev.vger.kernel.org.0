Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71292E6C72
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgL1Wzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729507AbgL1VWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 16:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18A232084D;
        Mon, 28 Dec 2020 21:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609190504;
        bh=ApxT1Nf+2pP0cBdrGwWdh9z4/q701vW794oke7Kb370=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ezE8b0yjdG3EoIhwcmkVv/T1NkqXL9sLzM7baA7rhcig4xqWGd1x5JJrYMTtQ9+BE
         IIEj7gf74GzaDZfYZsVgwfjBra4q3JjQ7lyr8wK8VU6gFd0WJE+hH40QAsb4Bu49Z5
         AQFzs/qMujVRPjWoX4KODpD2V1l3HahyjR14aPJgdyfok1IxYCKoLqyFaN6xHLSVZQ
         YMpxGbM60sYcPn8wct7TNvVOadJQw5fLV/qD6/BVhtLHZlNfmaTe838mMNxbZ2EFuQ
         MGhmToEhWIitWxkXx1q6V9+zA7tD6gC67Vp9B0sFqW9oAxNa+VZQjbRTCOQiBefTus
         yEXyepg+xIAqQ==
Date:   Mon, 28 Dec 2020 13:21:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next] net: nfc: nci: Change the NCI close sequence
Message-ID: <20201228132143.39edf28d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228014631.5557-1-bongsu.jeon@samsung.com>
References: <20201228014631.5557-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Dec 2020 10:46:31 +0900 Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Change the NCI close sequence because the NCI Command timer should be
> deleted after flushing the NCI command work queue.

The commit message should describe the reason - why new order is
better than the old one. The existing sentence describes what is
changing more than why.
