Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4459F881A
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 06:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfKLFiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 00:38:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45120 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725283AbfKLFiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 00:38:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573537089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bI9cFZVY4CTTkrZ9R2VeuU7RCd3pX4Bs823wGbBKyvE=;
        b=DtKQcw7RMXnt+LvrXWII9SGfL5SiuOiuoiT2vONb7+OAQ/oF/iN1YcuPdcC+tUtciHQnO6
        oOlrpz+Yuv8cgPnArBMf0lEIhCYA9WtMfVJByOFw/xVTQtDkg8e0pIrbZKG8peCYqyUEPP
        Za+u3qUmGkPS5QDARYZb8uiihsrrdD0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-FNwbJbUsOlKuIs6R05vIow-1; Tue, 12 Nov 2019 00:38:05 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4817B800EB3;
        Tue, 12 Nov 2019 05:38:04 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61F076015A;
        Tue, 12 Nov 2019 05:38:00 +0000 (UTC)
Date:   Mon, 11 Nov 2019 21:37:59 -0800 (PST)
Message-Id: <20191111.213759.2137329196314346577.davem@redhat.com>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        idosch@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net] mlxsw: core: Enable devlink reload only on probe
From:   David Miller <davem@redhat.com>
In-Reply-To: <20191110153123.15885-1-jiri@resnulli.us>
References: <20191110153123.15885-1-jiri@resnulli.us>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: FNwbJbUsOlKuIs6R05vIow-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sun, 10 Nov 2019 16:31:23 +0100

> From: Jiri Pirko <jiri@mellanox.com>
>=20
> Call devlink enable only during probe time and avoid deadlock
> during reload.
>=20
> Reported-by: Shalom Toledo <shalomt@mellanox.com>
> Fixes: 5a508a254bed ("devlink: disallow reload operation during device cl=
eanup")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied, and since the Fixes: tag commit is queued up for -stable, I'll
queue up this one too.

Thanks.

