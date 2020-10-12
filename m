Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E1C28BD5B
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 18:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390534AbgJLQPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 12:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390043AbgJLQPm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 12:15:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3D6C206CB;
        Mon, 12 Oct 2020 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602519342;
        bh=m/r6W5ffvoPXFOgetY/F6chx6bDQBz0FcqYoBawBtGg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cDxWHEjJXJFBthsjyOlrXBmzryAloRvfc/9rdRmmQ/HLSgBeNA7Oo0C+SDQRmIPvE
         Uuu/qwWB8lVq+m25sp/s0LP/a9R4XELzjIsV0DI5MtIkTldfukrF3mdf2CFGuEflzv
         L7iltoyMfEm9Cyz4RGUtF4NmsOr7WbZPNeKfj5AY=
Date:   Mon, 12 Oct 2020 09:15:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamie Iles <jamie@nuviainc.com>
Cc:     netdev@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH 3/5] bonding: wait for sysfs kobject destruction before
 freeing struct slave
Message-ID: <20201012091540.140e1c70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012131115.58843-1-jamie@nuviainc.com>
References: <20201012131115.58843-1-jamie@nuviainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 14:11:15 +0100 Jamie Iles wrote:
> syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, releasing a
> struct slave device could result in the following splat:

I don't know who you're expecting to merge this, but I'm tossing 
it from networking patchwork. Please resend as a stand alone patch 
if we're supposed to take it.
