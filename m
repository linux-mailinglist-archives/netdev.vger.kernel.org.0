Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3C7F881D
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 06:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfKLFi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 00:38:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31809 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725775AbfKLFi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 00:38:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573537138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/sw5XdNujAz/I31NJsdtfkevft5VZCJNijlCsTQFFuw=;
        b=TxKz7fuqz5/EgJHsncfWzjCwwNmpaB7AV758i481aw0KKSMydIL3c6rRoL/vK962sDRjfX
        EYkAA0mwbFnq/8VHTHeaANU81ZKSMWDYa+YGkHzbDZ4iooEi2We1T/JqxYNIMrExAL/gYf
        /vEq7oN5T3/kLV2JunVMFSFIZk8DzzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-L8_uJfd0NvSvPY9N8ulSfw-1; Tue, 12 Nov 2019 00:38:54 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B4AC8017E0;
        Tue, 12 Nov 2019 05:38:53 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B138360872;
        Tue, 12 Nov 2019 05:38:50 +0000 (UTC)
Date:   Mon, 11 Nov 2019 21:38:49 -0800 (PST)
Message-Id: <20191111.213849.1866746935055751968.davem@redhat.com>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        idosch@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next] mlxsw: core: Enable devlink reload only on
 probe
From:   David Miller <davem@redhat.com>
In-Reply-To: <20191110153144.15941-1-jiri@resnulli.us>
References: <20191110153144.15941-1-jiri@resnulli.us>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: L8_uJfd0NvSvPY9N8ulSfw-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sun, 10 Nov 2019 16:31:44 +0100

> From: Jiri Pirko <jiri@mellanox.com>
>=20
> Call devlink enable only during probe time and avoid deadlock
> during reload.
>=20
> Reported-by: Shalom Toledo <shalomt@mellanox.com>
> Fixes: a0c76345e3d3 ("devlink: disallow reload operation during device cl=
eanup")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied.

