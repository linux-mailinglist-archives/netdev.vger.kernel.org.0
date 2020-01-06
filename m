Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F0D131B05
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgAFWGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:06:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52239 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726721AbgAFWGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578348392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3uYCWZ9RB5xU25PEYg0bUiyIR2NQi6Hy7lZWG+FoCYs=;
        b=RN7IX8NfTh3t52Ex5go8DZCa3JwvnaFQdl5ezaRx2MObMB0Gn4eDNytf6TLLIfnfUCHDAj
        axJpxEdeWWgGC957Bd4IQglHgk1XgjK8fiZREsTpw1FbsQwImFlyZdzAmcVM1V56tWN/KZ
        Tp/ocnou09b2yv0KdArn9aP8/WMVmjo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-f8qYPJqAPOamekfMTiyQ8w-1; Mon, 06 Jan 2020 17:06:28 -0500
X-MC-Unique: f8qYPJqAPOamekfMTiyQ8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEF45800D5B;
        Mon,  6 Jan 2020 22:06:27 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9A367DB5B;
        Mon,  6 Jan 2020 22:06:26 +0000 (UTC)
Date:   Mon, 06 Jan 2020 14:06:25 -0800 (PST)
Message-Id: <20200106.140625.1713406724412109798.davem@redhat.com>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] Aquantia/Marvell atlantic bugfixes 2020/01
From:   David Miller <davem@redhat.com>
In-Reply-To: <cover.1578059294.git.irusskikh@marvell.com>
References: <cover.1578059294.git.irusskikh@marvell.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Mon, 6 Jan 2020 14:22:27 +0300

> Here is a set of recently discovered bugfixes,
> 
> Please integrate, thanks!

Series applied.

