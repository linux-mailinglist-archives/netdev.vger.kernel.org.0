Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F1F188ED7
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgCQUTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgCQUTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 16:19:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71FAF2051A;
        Tue, 17 Mar 2020 20:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584476346;
        bh=+mAcWjkJ9uLbZZxiu2WcQGRwtq+g4xGpLKmEB9r4ZS0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ro88F0YYn1gQ1iyElXrTmko1NRrpBr52R8Iocp+pFEvS7OChG0gQAy7Lvj7M1K6fV
         Nf5GVQbuNklmNXg4Z9JQ2P/BVpHDYmu0XtCy/ApuIlCI8qsfheVluMvs1wJKv9BSJ/
         Jd8LOYUneSizTr6ZHiVGVG507cB+oCOA/KeOkV+0=
Date:   Tue, 17 Mar 2020 13:19:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 0/5] ionic bits and bytes
Message-ID: <20200317131903.29b3655c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200317032210.7996-1-snelson@pensando.io>
References: <20200317032210.7996-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 20:22:05 -0700 Shannon Nelson wrote:
> These are a few little updates to the ionic driver while we are in between
> other feature work.  While these are mostly Fixes, they are almost all low
> priority and needn't be promoted to net.  The one higher need is patch 1,
> but it is fixing something that hasn't made it out of net-next yet.
> 
> v3: allow decode of unknown transciever and use type
>     codes from sfp.h
> v2: add Fixes tags to patches 1-4, and a little
>     description for patch 5

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
