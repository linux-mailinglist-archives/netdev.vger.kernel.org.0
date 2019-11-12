Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34E5F896C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 08:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfKLHNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 02:13:47 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34319 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725781AbfKLHNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 02:13:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573542826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+/PslG0x/GuyfOYX/QGY2CmojWWuenPENm2HBUOpPKE=;
        b=RhED8S8/rM3G6cJ52uSeWF8f4lnqaYu0xYFDQZ7VsnroyMHevVw/sctGmtEX00nP6mwpuy
        pYY3CXdXOTUrbeNegrBHPr66ymBq04erQbybal6bsAqd/ONOYAeV6r5f9lf/i5CdK/3SZ0
        44+pL9wpDxyOUtxef1bL4YGAQHex/oo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-H7j87F9JNhiJLtRPckSSlg-1; Tue, 12 Nov 2019 02:13:43 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D764800EB3;
        Tue, 12 Nov 2019 07:13:41 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C188060872;
        Tue, 12 Nov 2019 07:13:38 +0000 (UTC)
Date:   Mon, 11 Nov 2019 23:13:37 -0800 (PST)
Message-Id: <20191111.231337.234535765361161267.davem@redhat.com>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        mcoquelin.stm32@gmail.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] net: stmmac: Improvements for -next
From:   David Miller <davem@redhat.com>
In-Reply-To: <cover.1573482991.git.Jose.Abreu@synopsys.com>
References: <cover.1573482991.git.Jose.Abreu@synopsys.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: H7j87F9JNhiJLtRPckSSlg-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Mon, 11 Nov 2019 15:42:33 +0100

> Misc improvements for stmmac.
 ...

Series applied.

