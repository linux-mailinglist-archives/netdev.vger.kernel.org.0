Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D221E2B6F4D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbgKQTt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:49:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728309AbgKQTt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 14:49:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605642592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gw3E4N9Hb3B+L7R6xRkeoPN5sNRZ6UObVyv/hqFxbkA=;
        b=Xwwu/zkCCLrJFqGSQY1Uh0Muiz3gn/1QAEWE11b6x7KFus9ylqpsamFgECe9ZbIz+Y/a+b
        yPg7ASlHwaW2H1ydnre0pXuZ/nheP9vf3bHwo1DdfBKjVmmZZRyIZNDHmBM5tOjGDcHdTn
        5X5/uPGzq840IgCFqpRcOt2KmLWkiLg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-vWn3VtfEOjC-WxiiNUhrBg-1; Tue, 17 Nov 2020 14:49:50 -0500
X-MC-Unique: vWn3VtfEOjC-WxiiNUhrBg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BB08186DD2B;
        Tue, 17 Nov 2020 19:49:48 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-114-159.ams2.redhat.com [10.36.114.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AE225D9CD;
        Tue, 17 Nov 2020 19:49:48 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id C291CA80920; Tue, 17 Nov 2020 20:49:46 +0100 (CET)
Date:   Tue, 17 Nov 2020 20:49:46 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] [RHEL8.4 PATCH] igc: fix link speed advertising
Message-ID: <20201117194946.GH41926@calimero.vinschen.de>
Mail-Followup-To: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
References: <20201117194629.178360-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201117194629.178360-1-vinschen@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Nov 17 20:46, Corinna Vinschen wrote:
> Link speed advertising in igc has two problems:

Sorry for the RHEL tag in the subject, I'll resend the patch without
this.


Corinna

