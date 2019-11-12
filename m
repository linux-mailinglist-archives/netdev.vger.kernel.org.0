Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F169F8863
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfKLGIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:08:46 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22128 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725783AbfKLGIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:08:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573538924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5JuYx9LX1B3F0F2ID86mGVCOuOf7H9zcwWflEXLmjaU=;
        b=KhKmCN20PyzqFoF8pLI3DfIhKMDetUXEUXGkXnizaWgzG839a0SxP5/BIsSYgnEliPqZID
        QroNyVB9dvniFh8F9p9akDRCVxjPNCU6qNRSFqfvtZ0o0JEzW9WDTS3+X1V3SFbByTW64C
        COeCCrH6yCQMVSH35jFUME3kCRGMuec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-ojL1uDpYOwCRhUxzoJgkng-1; Tue, 12 Nov 2019 01:08:41 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 310341800D7A;
        Tue, 12 Nov 2019 06:08:40 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D1635DF2B;
        Tue, 12 Nov 2019 06:08:38 +0000 (UTC)
Date:   Mon, 11 Nov 2019 22:08:37 -0800 (PST)
Message-Id: <20191111.220837.197601774699090400.davem@redhat.com>
To:     zhengbin13@huawei.com
Cc:     vishal@chelsio.com, netdev@vger.kernel.org
Subject: Re: [PATCH] cxgb4: make function 'cxgb4_mqprio_free_hw_resources'
 static
From:   David Miller <davem@redhat.com>
In-Reply-To: <1573478770-79161-1-git-send-email-zhengbin13@huawei.com>
References: <1573478770-79161-1-git-send-email-zhengbin13@huawei.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: ojL1uDpYOwCRhUxzoJgkng-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>
Date: Mon, 11 Nov 2019 21:26:10 +0800

> Fix sparse warnings:
>=20
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c:242:6: warning: symb=
ol 'cxgb4_mqprio_free_hw_resources' was not declared. Should it be static?
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

I'm not applying any more of these Hulk robot fixed until you fix your Subj=
ect
lines to indicate the appropriate target GIT tree your patches should be
applied to.

You also need to provide appropriate Fixes: tags as well.

