Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9002219C64E
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 17:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389448AbgDBPrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 11:47:13 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36167 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388677AbgDBPrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 11:47:13 -0400
Received: by mail-qt1-f194.google.com with SMTP id m33so3663889qtb.3
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 08:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=3SVv2ugMxS46wTzXW7lQ8FYVphicqiD0yWzt0V9lWqM=;
        b=oM2mnNt+Da4yan/CuYqdjNv9lyRH+AZirotPamlybilH1mNPPBo31F4Y8ojXGMT/qR
         jYAjKJSAPPyAJDKr860PDrnB9IkpPhiRksR3Agic+rnVT+acP0ffrg1xk5xpDkHxybhR
         jd7j+l82iL/OWQLPXcLPd0apHAJ2maDZ08HRaqLzA9MFXphNI316MJaoz281teyZ59vG
         J1G3rHH8prKqWkeuPgI/LyI6WfA/0lufjXHBXGZokOwEofVC8IiLc4XfvaJSc2Z2z+dU
         vNfzODFAEYorTBDQb9Rr9Wy0P1Eulx9gujbV8668d37zBg/Lo9tpbHBWVpYdasO2kejW
         +tKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=3SVv2ugMxS46wTzXW7lQ8FYVphicqiD0yWzt0V9lWqM=;
        b=WhasMgwRtfDgqPg8dmDHGwzclN2/bFiIE1lVBWCgK+ZRVU3IFk1xnGy67gIsGe8W2a
         nmxFJ9YLVVw5YafXa8TDSf2psJYu59uXxIHIZ3LNRhkulK37Ru57PuLq0nd9o+oLZ0+1
         hX5WqrqSjxrvt+iNVRXoAXUsMan/OflMkOtkx+Py+74HV0c3FaFE9qp6X99DqPQ1oerL
         hmMvd5pnSHuii711S5i+AGF/30Gohmg/RMQgwwLYHuzTypptiJslD8pBVMM+9aS/pHR7
         /Yzhmzf1pu+Rs6GNMf/h93vF+QILqAvKjTpYVHcIhM3MFBAV6sZ9CFkwxJ3E0YvJPWWS
         vdFA==
X-Gm-Message-State: AGi0PuYJ4TPsn5X8E2hSZs+gdZCu3Kal2YnGF9zuByxInmPLK+tYXI8v
        QAEGpGBYNtKcw3Q3NyxmC+nOe8LS
X-Google-Smtp-Source: APiQypIIXCpdFgZenUP6zPT6STB53cnU/6PTIvRFoshz+roMfPBteP3BpP959FOvJqnsYLIlwRAHaw==
X-Received: by 2002:ac8:4f4f:: with SMTP id i15mr3503712qtw.329.1585842432230;
        Thu, 02 Apr 2020 08:47:12 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id u51sm4015897qth.46.2020.04.02.08.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 08:47:11 -0700 (PDT)
Date:   Thu, 2 Apr 2020 11:47:10 -0400
Message-ID: <20200402114710.GD1775094@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: dsa_bridge_mtu_normalization() can be
 static
In-Reply-To: <20200402102819.8334-1-olteanv@gmail.com>
References: <20200402102819.8334-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Apr 2020 13:28:19 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: kbuild test robot <lkp@intel.com>
> 
> This function is not called from any other C file.
> 
> Fixes: bff33f7e2ae2 ("net: dsa: implement auto-normalization of MTU for bridge hardware datapath")
> Signed-off-by: kbuild test robot <lkp@intel.com>

Did you mean Reported-by? I don't think kbuild test robot signed that.

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Jason sent a patch already.

Thanks,
Vivien
