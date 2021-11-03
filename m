Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F6C443A8C
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhKCAoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230331AbhKCAoW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 20:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C86BD60EBC;
        Wed,  3 Nov 2021 00:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635900106;
        bh=/WrZlOaVnQz3Cv8QglJ9YBS6nYH6HXnCreNsZUGxDRs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gotiHQhN3W6JRLA2Rsc0GaD2RW8ujzPaCWNZjEunObM+Y0QGDCMohEmM0KLQGnE+Y
         ON11TKBfKBNTrTZpXdLoaxWmg6yS1S37Rq8K4S+biS4cxvE6GXYhg4Y5XmLMgcvGbX
         cvnCTuCcNQ99bXPmTf4wH8uqBNEn9hlaqc+kmXAhtT3Vwl3MGd/RRUn/3VSOi6dmXr
         Pm5TB3eM7cx64SfVPLpM6t9kcL/hmzhWd5gcIWtkOraXeqnfcOG7oPep4w+vwOQocy
         1u9WwqEZDmj6z/tmHgtU9QBM7wvgd3rSjfF8AfRw3MBOCQfXgpaVHr4j6uUel7Fv2C
         qf2LK1d+crE7A==
Date:   Tue, 2 Nov 2021 17:41:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2021-11-01
Message-ID: <20211102174143.298552dc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20211101175100.216963-1-anthony.l.nguyen@intel.com>
References: <20211101175100.216963-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Nov 2021 10:50:55 -0700 Tony Nguyen wrote:
> The will conflict when merging with net-next.

Please rebase now.
