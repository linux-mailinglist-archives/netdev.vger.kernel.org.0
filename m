Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1C4274781
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIVRc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVRc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 13:32:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21DA122206;
        Tue, 22 Sep 2020 17:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600795948;
        bh=gGcnCw1jkxH4jbg4uouQwTERCTzASyZTteWSk7+CrCA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=udPEdYHCcZGEl5BoQyjHbPadCMeWG9qr4qWFj62JMDaHQ/GgvVky3oefg8kyzdY4E
         cqUEkM16RInFZWJqX2L7gaLJmfad+7A6mJV4N90t9xlVPMiGm2vx/sbWBzTP5MoXl9
         Pnp56dmvRVinvPWAS05MOaU5iT94U+/OnbcATUec=
Date:   Tue, 22 Sep 2020 10:32:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v2 1/3] gve: Add support for raw addressing
 device option
Message-ID: <20200922103226.1e8b90e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200922155100.1624976-2-awogbemila@google.com>
References: <20200922155100.1624976-1-awogbemila@google.com>
        <20200922155100.1624976-2-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 08:50:58 -0700 David Awogbemila wrote:
> +	dev_opt = (struct gve_device_option *)((void *)descriptor +
> +							sizeof(*descriptor));

You don't need to cast void pointers to types.

The idiomatic way to get end of structure in C is: &descriptor[1] or
descriptor + 1.
