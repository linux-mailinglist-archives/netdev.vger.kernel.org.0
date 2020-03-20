Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B798718C60E
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 04:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgCTDqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 23:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgCTDqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 23:46:43 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9654F20722;
        Fri, 20 Mar 2020 03:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584676002;
        bh=anZrVUWfKJop2VdpD9ssVfUcTbPAsbH+vUAJCPNWe5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nBQ5CdbwJCpafCucrpVwepXuhzHB0dOpKP+FbqUWvH4537FvU5oUYleCUMWahYCBF
         IHShhyWYBPq0RX0+hIBq/2TSDxuVLi9CcEnlc5zOdW1HdKOVLHoHQ6s+rOXeU2kfGR
         8jdGqctsys51B0bLtL34B3ebE4PL6UbU0tHzAclc=
Date:   Thu, 19 Mar 2020 20:46:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 0/6] ionic error recovery fixes
Message-ID: <20200319204640.36626901@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200320023153.48655-1-snelson@pensando.io>
References: <20200320023153.48655-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Mar 2020 19:31:47 -0700 Shannon Nelson wrote:
> These are a few little patches to make error recovery a little
> more safe and successful.

Patches looks good to me, FWIW. Thanks for dropping the controversial
one. I think this should have been v2 since we seen most if not all of
these.

I'm not sure why most of them have a Fixes tag, though. The
AUTOSEL bot is quite likely to pull them into the stable trees once
they land. Is this some intentional strategy on your part?
