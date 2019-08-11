Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558EE89178
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 12:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfHKKt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 06:49:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36963 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfHKKt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 06:49:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id z11so162268wrt.4
        for <netdev@vger.kernel.org>; Sun, 11 Aug 2019 03:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E78SJ0Wx+p4WUVJGdn+lRCXRUxyY8ZQuys3hsU4+Pbg=;
        b=fyTp7cdcTGEY/z6qmXwILd8MJX5L4bFJzoNqv+qOBN0+E2tbdS6kM1zWHGEc+WMFTP
         x6LnAwTSmYE79vPTGyf5wOz52EkpjQTdMCuo50dULM8KYV7n2CNaJys9x6xynleRhQqi
         QynovTHwQ0vW5CGKUsL+6LbKpOEtYt5slqK9Qvhh258qDDR8xMdMXgvEYbp5M+FAkCzR
         EFZP9mbuIhDEV7lwAdrquGIC1/zjt3frNc/H4ASJ5rkQmKv+MGJSijUSC7Meu/ixMY6q
         qSPhWSEWXaj2Yl6Luupzj6MoaO4oua/OyfarhHEBHOFRmBTenislhnzTdsqlsxr6X89T
         QBcQ==
X-Gm-Message-State: APjAAAWmvXDMRSQdWm7FvteBTPXTWdr5r/4G0aE7g18M+QSeXbaZNHa3
        HnYH8mQXwn1mEl8B4JELJK6tZnYY
X-Google-Smtp-Source: APXvYqxSd3h8oHTz6LvtrAtCZl19KIOdEFPI4jkugfz47+BbK2BmVbqu5GEJgHTg0ekVKP29z/vRQQ==
X-Received: by 2002:adf:fcd1:: with SMTP id f17mr22060436wrs.252.1565520566919;
        Sun, 11 Aug 2019 03:49:26 -0700 (PDT)
Received: from debian (30.163.200.146.dyn.plus.net. [146.200.163.30])
        by smtp.gmail.com with ESMTPSA id 25sm10037491wmi.40.2019.08.11.03.49.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 11 Aug 2019 03:49:26 -0700 (PDT)
Date:   Sun, 11 Aug 2019 11:49:24 +0100
From:   Wei Liu <wei.liu@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul.durrant@citrix.com>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Subject: Re: [PATCH] xen-netback: no need to check return value of
 debugfs_create functions
Message-ID: <20190811104924.kzso22ke7jagjvyj@debian>
References: <20190810103108.GA29487@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190810103108.GA29487@kroah.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 10, 2019 at 12:31:08PM +0200, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: Paul Durrant <paul.durrant@citrix.com>
> Cc: xen-devel@lists.xenproject.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Wei Liu <wei.liu@kernel.org>
