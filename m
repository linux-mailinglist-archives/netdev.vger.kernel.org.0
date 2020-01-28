Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E57514AE96
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 05:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgA1EH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 23:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgA1EH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 23:07:57 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B7D324656;
        Tue, 28 Jan 2020 04:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580184477;
        bh=bXL6K0QE4oV3d4OAKD4tfYv0fF8EcvXlOLBZH7VbWW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pHJZi3JQ8VBydnGN6/eE5JoFBSMN2/9zt0Hy/jisHni9AXVq22a4qNoRkFNg59tAV
         Ild7rLUxTJS3wsTElXTdYSn2Dd0Rm5y9Xoo0/JHCDMOMU6du7e8Jzc7tyWAxr2Yh5h
         KC3ZtNsTpxzHqt+AXRt2T+0PGKlSA4mHa++CHSmg=
Date:   Mon, 27 Jan 2020 20:07:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 6/6] netdevsim: remove unused sdev code
Message-ID: <20200127200756.1f9164aa@cakuba>
In-Reply-To: <20200127143109.1644-1-ap420073@gmail.com>
References: <20200127143109.1644-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 14:31:09 +0000, Taehee Yoo wrote:
> sdev.c code is merged into dev.c and is not used anymore.
> it would be removed.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Ah, good catch, it's not even in the Makefile!

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
