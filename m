Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6A41FD1EC
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgFQQZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgFQQZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 12:25:29 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E5702071A;
        Wed, 17 Jun 2020 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592411129;
        bh=7iuf3eDoW1mlVDHBSFWYiLHHIn/K5bUD/kC3mfLzCWY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PFIpfyYVnWEgX6EokdT3XECdYOb8diJxpA8OBpClyiA0se0t+h1F1CVatc8rpNue0
         22dFAsF44SUymvmLIJzzsCJ6heQ7prOV31mXAETpV2CytblAWvrRhu3jfveyjFUcUV
         ZhBMSKBSwomLDK7rulB3zg7p5nlsk5zqKBnFi3Do=
Date:   Wed, 17 Jun 2020 09:25:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next 3/5] cxgb4: add support to flash boot image
Message-ID: <20200617092527.30333c1f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200617062907.26121-4-vishal@chelsio.com>
References: <20200617062907.26121-1-vishal@chelsio.com>
        <20200617062907.26121-4-vishal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 11:59:05 +0530 Vishal Kulkarni wrote:
> Update set_flash to flash boot image to flash region
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

This patch adds 4 new warnings to the plethora of warnings in
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c when built with W=1 C=1 flags.

Please don't add new ones. And preferably address the existing
hundreds of warnings in your driver.
