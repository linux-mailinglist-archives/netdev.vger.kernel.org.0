Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1BA29F9F0
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgJ3Apn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ3Apm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 20:45:42 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E143820691;
        Fri, 30 Oct 2020 00:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604018742;
        bh=mftwcMMw5XwqUWF0cScDj6V9bDZv3PmO9yqsg7xjDQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2pvKoptW9TSIq1SnT+dBrNnZszUqZnN3WYcTmDcrM+FO1ccMCMe3bmZBjENhxA27e
         VghMWBZe20XW5sLdX9eCcmS2bFQ3C160c3fm1Tmy16q68U7XHh5X1pRhV/sElsLnb4
         J0Orf/+sG5CIqPZpNz3iO7VPcJlu1ojjUOfCvSdY=
Date:   Thu, 29 Oct 2020 17:45:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] vsock: minor clean up of ioctl error handling
Message-ID: <20201029174540.72ed5fe7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027090942.14916-1-colin.king@canonical.com>
References: <20201027090942.14916-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 09:09:40 +0000 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Two minor changes to the ioctl error handling.

Applied, thanks!
