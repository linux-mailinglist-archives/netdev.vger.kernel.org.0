Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B5D2B1423
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgKMCGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:06:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgKMCGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 21:06:31 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 175FB207DE;
        Fri, 13 Nov 2020 02:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605233191;
        bh=YkUNoDCGh5Iy3gGNDOGrM4QjsVXskmcERAbmvOxKo1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eofTRfbReqheEfhX/gy7BIOCHwwJr46NKH5+vsk8UJdxY92zWDjv/gHYo5+2emNQy
         c7L94LCm4DaKgugmwS1ZEBq5Tm8EURedls/INorlQ/VXVXnVQ1nHVRf4+wGYiTT46Y
         qQEPACyGYIIouIzozVdeQ5WbatwOPdUuLLelHwXk=
Date:   Thu, 12 Nov 2020 18:06:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] netdevsim: support ethtool ring and
 coalesce settings
Message-ID: <20201112180630.03f0e512@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112151229.1288504-1-acardace@redhat.com>
References: <20201112151229.1288504-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 16:12:29 +0100 Antonio Cardace wrote:
> Add ethtool ring and coalesce settings support for testing.
> 
> Signed-off-by: Antonio Cardace <acardace@redhat.com>

Please add a test to tools/testing/.../netdevsim/

We don't add functionality to netdevsim unless there is a in-tree test
that exercises it.
