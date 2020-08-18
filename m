Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECACC248E51
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgHRS5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgHRS5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 14:57:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD86F20786;
        Tue, 18 Aug 2020 18:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597777021;
        bh=Fce3Bc0Vz4cIqHcv0EaS/4XCJthY051NcIN1NAJ4JQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TDEAdvn0zSDeogBjlbkNGq791eZNw/5eqOUY29mInagKTbD01QZR94A3K5uYRIKAw
         jjXsQVqjA/2BUzTstexzTA3Jt9fieuXnKW7AyzenAehB3b1Oc8DLDkGYcJLAHF8Puu
         9uo3/LATXZoOPkv5VbsoOjYW/VzgXCibsiY3v7EQ=
Date:   Tue, 18 Aug 2020 11:57:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     jchapman@katalix.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] Documentation/networking: update l2tp docs
Message-ID: <20200818115700.6a8b05ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818151135.1943-1-jchapman@katalix.com>
References: <20200818151135.1943-1-jchapman@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 16:11:35 +0100 jchapman@katalix.com wrote:
> From: James Chapman <jchapman@katalix.com>
> 
> Kernel documentation of L2TP has not been kept up to date and lacks
> coverage of some L2TP APIs. While addressing this, refactor to improve
> readability, separating the parts which focus on user APIs and
> internal implementation into sections.
> 
> Signed-off-by: James Chapman <jchapman@katalix.com>

Hi James, checkpatch --strict notices some trailing whitespace here:

ERROR: trailing whitespace
#301: FILE: Documentation/networking/l2tp.rst:177:
+PW_TYPE            Y        Sets the pseudowire type. $

ERROR: trailing whitespace
#348: FILE: Documentation/networking/l2tp.rst:224:
+CONN_ID            N        Identifies the tunnel id to be queried. Ignored for DUMP requests.    $

total: 2 errors, 0 warnings, 0 checks, 927 lines checked

Could you clean these up?
