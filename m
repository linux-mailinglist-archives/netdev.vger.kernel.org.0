Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4010E28D766
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 02:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgJNAYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 20:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgJNAYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 20:24:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D059207DE;
        Wed, 14 Oct 2020 00:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602635050;
        bh=AIv5ceHAyZCZad6fxInfruE+0jFPYfcHlsra7dB8X98=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0rwZlxw4hoIK6CwaGSZbWfFEcb19tf5Dl5ZxvLxryDAhRK5wYMpRMHyBwNRxBSxzl
         /kHKsYvb3Ij+e8BEFPhMVRmYqIjpNfncA0rqYth4XvzoQnJQ/2wtw+RCqAT4GPeNQ4
         FtniWrRu3n+9SwwejA7nzbnaL1unuzX5I9yUssvU=
Date:   Tue, 13 Oct 2020 17:24:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Or Cohen <orcohen2006@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Or Cohen <orcohen@paloaltonetworks.com>
Subject: Re: [PATCH] net/af_unix: Remove unused old_pid variable
Message-ID: <20201013172407.0d1ca4ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011153527.18628-1-orcohen@paloaltonetworks.com>
References: <20201011153527.18628-1-orcohen@paloaltonetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 18:35:27 +0300 Or Cohen wrote:
> Commit 109f6e39fa07c48f5801 ("af_unix: Allow SO_PEERCRED
> to work across namespaces.") introduced the old_pid variable
> in unix_listen, but it's never used.
> Remove the declaration and the call to put_pid.
> 
> Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>

Applied, thank you.
