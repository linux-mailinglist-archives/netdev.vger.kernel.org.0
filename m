Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD1B192FF4
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCYR4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgCYR4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 13:56:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6409E206F6;
        Wed, 25 Mar 2020 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585158970;
        bh=YwPjdZJNqrQcjC1PKVYfHeOg+tRZT+OKwQ21NuDgRGg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ambj0ETkawa8Halt9b2sXA6MPyKMrC+W9IpZynEyXCd+c/1owoL9gellkfa3EPE+3
         n+Z/viPRGrwTKVujVIhnFmskEwqzeN72zLrajghcNlRazEcosmBLaadnBq6sE/C04/
         SWt4l0WEAuFP0s2LmXdx3bp4Y1J4E9Ka5uH6u4yw=
Date:   Wed, 25 Mar 2020 10:56:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH 04/10] devlink: add function to take snapshot while
 locked
Message-ID: <20200325105608.13077942@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200324223445.2077900-5-jacob.e.keller@intel.com>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
        <20200324223445.2077900-5-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 15:34:39 -0700 Jacob Keller wrote:
> A future change is going to add a new devlink command to request
> a snapshot on demand. This function will want to call the
> devlink_region_snapshot_create function while already holding the
> devlink instance lock.
> 
> Extract the logic of this function into a static function prefixed by
> `__` to indicate that it is an internal helper function. Modify the
> original function to be implemented in terms of the new locked
> function.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
