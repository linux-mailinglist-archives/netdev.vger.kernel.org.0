Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E19AF885B
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 07:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfKLGDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 01:03:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48563 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725775AbfKLGDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 01:03:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573538612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ho2XsNUpIsBi4WZFCCaKTISu0ba10Fa9pDqy6quVqcg=;
        b=P1WCijyivNAQ15byZo4uEybJSBffdM4h67PVmHyJherxESLOczoIEIwtN5EcuikUQFQPrA
        jXCRY1lq3GFUDgcbi+8PD+lyYZ6PoBl0ATUmoKcJNFixNMI1kqaJdUg35BcVQickPm0UsX
        CcCFhisvaiEPh+zuosh8KuKdqyqkozg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-0tlUVX-MPcK880JyqerVoQ-1; Tue, 12 Nov 2019 01:03:28 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9955085EE72;
        Tue, 12 Nov 2019 06:03:27 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4117B600CD;
        Tue, 12 Nov 2019 06:03:25 +0000 (UTC)
Date:   Mon, 11 Nov 2019 22:03:24 -0800 (PST)
Message-Id: <20191111.220324.1668294384096794671.davem@redhat.com>
To:     madalin.bucur@nxp.com
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH net-next 0/2] dpaa_eth documentation updates
From:   David Miller <davem@redhat.com>
In-Reply-To: <1573473792-17797-1-git-send-email-madalin.bucur@nxp.com>
References: <1573473792-17797-1-git-send-email-madalin.bucur@nxp.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 0tlUVX-MPcK880JyqerVoQ-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>
Date: Mon, 11 Nov 2019 14:03:10 +0200

> Documentation updates for the DPAA Ethernet driver

Series applied to net-next.

