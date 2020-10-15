Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089D328EB7B
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 05:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgJODYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 23:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbgJODYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 23:24:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D7B422241;
        Thu, 15 Oct 2020 03:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602732241;
        bh=/uQkY14G6M1fz0Mf1kpDfvkYSJLA46KZEFtAxYMat3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d+ZDr1715zSnjT5AuE597fKuO4ZS+ZJ7hskT/3xdaEBi98O863sarRDo5chEfhDHE
         /Hj2pkIm7arC3DZNQTuqNw8I65WoEW4XL4FS2vDgD2hRluZzSOws/J70NUZMPZMHBG
         byvDdZCeINS5vB/zaEBfXrpeXUkRtHKEStPdaQSQ=
Date:   Wed, 14 Oct 2020 20:23:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Wilder <dwilder@us.ibm.com>
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [ PATCH v2 1/2] ibmveth: Switch order of ibmveth_helper calls.
Message-ID: <20201014202358.332a7882@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013232014.26044-2-dwilder@us.ibm.com>
References: <20201013232014.26044-1-dwilder@us.ibm.com>
        <20201013232014.26044-2-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 16:20:13 -0700 David Wilder wrote:
> Fixes: 66aa0678efc2 ("ibmveth: Support to enable LSO/CSO for Trunk
> VEA.")

Please make sure Fixes tags are not wrapped in the future.
