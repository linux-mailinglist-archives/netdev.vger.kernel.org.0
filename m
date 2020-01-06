Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50765131A97
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgAFVjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:39:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44781 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726713AbgAFVjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578346739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f0LgFNwZxihKfuviANiCqT3WVQL5fQ8EuZV/o+jTQC4=;
        b=d+tCQ99rTCvN7+rTRZ+HXeAhgJscB354RChdh66pYt/xL8IltghHxvF3I/kMVR8t797Bc7
        6Q9FUaKhtzPpNhMsys6dc3VKZ0xzBDc/5TuCa+bD17OMqv0AFrWFssmS9zNe7PrNG428G3
        9Up7Xiu8O8dyckesIRJiukoO8zDCnqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-ommxtHHzN_y21C5mKPV7Zg-1; Mon, 06 Jan 2020 16:38:55 -0500
X-MC-Unique: ommxtHHzN_y21C5mKPV7Zg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F215D801E76;
        Mon,  6 Jan 2020 21:38:53 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A4557DB5F;
        Mon,  6 Jan 2020 21:38:51 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:38:50 -0800 (PST)
Message-Id: <20200106.133850.2113771138393198443.davem@redhat.com>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/8] mlxsw: Disable checks in hardware pipeline
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200105162057.182547-1-idosch@idosch.org>
References: <20200105162057.182547-1-idosch@idosch.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun,  5 Jan 2020 18:20:49 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Amit says:
> 
> The hardware pipeline contains some checks that, by default, are
> configured to drop packets. Since the software data path does not drop
> packets due to these reasons and since we are interested in offloading
> the software data path to hardware, then these checks should be disabled
> in the hardware pipeline as well.
> 
> This patch set changes mlxsw to disable four of these checks and adds
> corresponding selftests. The tests pass both when the software data path
> is exercised (using veth pair) and when the hardware data path is
> exercised (using mlxsw ports in loopback).

Series applied, thanks.

