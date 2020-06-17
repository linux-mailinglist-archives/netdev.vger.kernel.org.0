Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0631FD4BA
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgFQSmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:42:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37587 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726851AbgFQSmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:42:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592419374;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sORNGbh4DVotTN6EW6Lo1a2t5jNMigfInKXxBxVJLYw=;
        b=TxKaPDDo0VVnysy8YvSUzpW5vbixRqaAR/PT+cKltxCGE/uE9QnvvKvNiRj+dq9rkScxwr
        YpufQ/S6Yvb3ummxozTKGAALwwnBVEQW0wIjkCqyzYdiNC0GN+rnyHjOJMNLBl6f/GXhhx
        k6DTARVM1fT/FCq2tXCgFe0YKAC6Co8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-xCDEO3eIN7-nkWqi8JaVAg-1; Wed, 17 Jun 2020 14:42:48 -0400
X-MC-Unique: xCDEO3eIN7-nkWqi8JaVAg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 214EE835B43;
        Wed, 17 Jun 2020 18:42:47 +0000 (UTC)
Received: from jtoppins.rdu.csb (ovpn-112-156.rdu2.redhat.com [10.10.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C54F879301;
        Wed, 17 Jun 2020 18:42:46 +0000 (UTC)
Reply-To: jtoppins@redhat.com
Subject: Re: [PATCH net] ionic: export features for vlans to use
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20200616150626.42738-1-snelson@pensando.io>
From:   Jonathan Toppins <jtoppins@redhat.com>
Organization: Red Hat
Message-ID: <2696fad4-85e1-c969-438b-ce8f61c3d6b7@redhat.com>
Date:   Wed, 17 Jun 2020 14:42:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200616150626.42738-1-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/20 11:06 AM, Shannon Nelson wrote:
> Set up vlan_features for use by any vlans above us.
> 
> Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
Acked-by: Jonathan Toppins <jtoppins@redhat.com>

