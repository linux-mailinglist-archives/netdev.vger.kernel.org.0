Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1721F6ED2
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 22:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgFKUeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 16:34:06 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42078 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725782AbgFKUeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 16:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591907645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SQbKg3UFY7FrbKtLcWPKiMVez16pv2xo8ZrBLK34aH0=;
        b=aDE3/yoKWu9PDBIspZ3Gz90d0ou/OIsILs+NOHDatiwhfsTcowsr6bRbnkyYMrvchabQFc
        AR80Bdhv+kxMTzrAjqc3EtmFlS03XbHc7sH5ASygcN6ZyuxTs4L4hWF73egy3C339lnRT+
        RAiaoranYx291W3P328/Y6nLKjkT7sQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-SJSP2mTOMFqA7taPH1vehQ-1; Thu, 11 Jun 2020 16:34:02 -0400
X-MC-Unique: SJSP2mTOMFqA7taPH1vehQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B73AEC1A0;
        Thu, 11 Jun 2020 20:34:01 +0000 (UTC)
Received: from [10.40.192.51] (unknown [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6C3F78EE1;
        Thu, 11 Jun 2020 20:34:00 +0000 (UTC)
Subject: Re: [PATCH net] ionic: remove support for mgmt device
To:     Shannon Nelson <snelson@pensando.io>
References: <20200611040739.4109-1-snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
From:   Michal Schmidt <mschmidt@redhat.com>
Message-ID: <9bf6b140-f099-29ce-011e-e46c950b8150@redhat.com>
Date:   Thu, 11 Jun 2020 22:33:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200611040739.4109-1-snelson@pensando.io>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dne 11. 06. 20 v 6:07 Shannon Nelson napsal(a):
> We no longer support the mgmt device in the ionic driver,
> so remove the device id and related code.
...> @@ -252,8 +248,6 @@ static int ionic_probe(struct pci_dev *pdev, 
const struct pci_device_id *ent)
>   	}
>   
>   	pci_set_master(pdev);
> -	if (!ionic->is_mgmt_nic)
> -		pcie_print_link_status(pdev);

Was removing the call intentional? Notice the condition is negated.

Michal

