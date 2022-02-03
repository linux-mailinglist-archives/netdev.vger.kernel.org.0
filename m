Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21414A9045
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355311AbiBCVxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiBCVxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 16:53:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A159DC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 13:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A555B835AB
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 21:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E9EC340E8;
        Thu,  3 Feb 2022 21:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643925191;
        bh=FT8PvonphWsVUrqAC6fv3GlN4EY4+ACY6vWYxSfAYeo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n9EG2Dl/qW5sE9wFw9BzB2YzxzxBCa0d0TUHgn1qXCGvul611ty41x5fiU4AEVuu3
         N04CaxnofX8MZL2QOfvhNRcpBTOsbQ6Kjj6oQgkRuDNKw3Asq9KU8teVoY7AJXjeAm
         dwOURvWrZI9SGang/XlkxnxZWF5rRV+vwtM3xk957knLiwDRVW0atKxnJooTc3isSD
         ykl7ZceYranI22WGvbg9smoWnPJsV7xSyC29lGcI1hCyvUxGYrJDS3c0BZWL6un49H
         TqqdaRYilmnrEZnKOmD0SkLi/pm06qor2Hb31PG0JMxEOpbr8uS5fJanwFkOJptyUh
         qTbXo5ymZqTCg==
Date:   Thu, 3 Feb 2022 13:53:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] sunhme: fix the version number in struct
 ethtool_drvinfo
Message-ID: <20220203135309.159cc440@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3152336.aeNJFYEL58@eto.sf-tec.de>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
        <3152336.aeNJFYEL58@eto.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Feb 2022 17:22:23 +0100 Rolf Eike Beer wrote:
> Fixes: 050bbb196392b9c178f82b1205a23dd2f915ee93

This is not the correct format for a fixes tag, FWIW.
