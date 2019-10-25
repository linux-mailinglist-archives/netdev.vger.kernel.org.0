Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E355FE53D9
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfJYSnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:43:45 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46628 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfJYSnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:43:45 -0400
Received: by mail-qk1-f194.google.com with SMTP id e66so2670425qkf.13
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=TBAC49l5tZeBpeQPmWJmHGawH/banyJ3ikzCa3F7EPw=;
        b=Xpwlh0P9XRojTME6YAb5LwbMGPVzgibmCcHKZUuja2URc/CSIyH39Ub5baQWCwCuBg
         KSfwUfPmmFQtyDKyM3Y1Ki1ai3aoafWVd0/r20Zm9vsyllr8DSMWhGxMTZThNnqVfpNY
         IagKtW7TJyz16QxWXTcOBZFQ8wJSYYICxZto8St1jezf1fZlRaLa/ACIuhtKgpkB6oYV
         Kpq2GDpxojw9LHLaoX+ywgsG1HdFeBIwbHW4UWrGhNBMnrb/w4FsJW5Al6PJmU6h+rid
         xfOwcEonsGPwpbMDcsNnqcVZqDUBRAtPrGw6DeF2Zl44x800EubuN7aGiIPRtvMB9F8I
         HMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=TBAC49l5tZeBpeQPmWJmHGawH/banyJ3ikzCa3F7EPw=;
        b=fZKjTtKDAIUA6gWxHScTiD0b/4rXsoG+eeeQPe0Nkg/CWxQtychCzcGEeJIlzSrLUg
         ajdThl8bLY7jWpNToJRKSnuxf141xq8kltA8I4SV+vGly12OcMPYxamL97B/r0HUFM4j
         dvPFBWUsb6vvxWgQhCYx5Z83HA5ojGpRnbOAcUzBw0/bwAmy7zTjh8DBktsqLhvw7f1I
         Rnp3G3kXw/+t7NKFON08T1QMZhp7UJPDzwUf3JEnIs5KFKfLRc9XvgYH3s+4skogw+Z2
         KgymeYGJTAysaIk36R4GdxP+Qm1kmNAQS7JekAT6X60glaIvZiqwc+7CPeE6Lki1EeDg
         jnRw==
X-Gm-Message-State: APjAAAXs2XtM8bubqgJhb3rBvcjjVrSMpjBJBfSQHJ8eN1/Xy+2dofPa
        +4NWfHHZh1RHk7NL5RXtpK4=
X-Google-Smtp-Source: APXvYqwQRQK3FwFCu40yVGiYA/1ryyR1BfNit01BkVm9DbvRTeZEYOWc+PF/Apgesa7vTIW8RkCqfA==
X-Received: by 2002:a37:8245:: with SMTP id e66mr4277774qkd.355.1572029024534;
        Fri, 25 Oct 2019 11:43:44 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id v13sm812994qkv.132.2019.10.25.11.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 11:43:43 -0700 (PDT)
Date:   Fri, 25 Oct 2019 14:43:42 -0400
Message-ID: <20191025144342.GB1371059@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        andrew@lunn.ch, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: b53: Add support for MDB
In-Reply-To: <20191024194508.32603-2-f.fainelli@gmail.com>
References: <20191024194508.32603-1-f.fainelli@gmail.com>
 <20191024194508.32603-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 12:45:07 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> In preparation for supporting IGMP snooping with or without the use of
> a bridge, add support within b53_common.c to program the ARL entries for
> multicast operations. The key difference is that a multicast ARL entry
> is comprised of a bitmask of enabled ports, instead of a port number.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
