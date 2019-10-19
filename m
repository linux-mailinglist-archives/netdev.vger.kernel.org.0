Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A617DDAAB
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfJSTUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 15:20:18 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41007 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJSTUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 15:20:18 -0400
Received: by mail-qk1-f195.google.com with SMTP id p10so8510250qkg.8
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 12:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=xoA9I9BIbFbMjr7xzglaSYMirU7cxPy7mUCKMopyv/Q=;
        b=n+vEiG92zzdx+efJ2o1rJpXpdX+B0wFjy5POuL3rUs3cHgTY58c1FwJ1S9JZeZwQEt
         ONFjpmU93h3J/uc/RjyLGJeZ07tkGtmFCWVAYY5UFYQM+yDWGvtFH4SKIyy7hBitHFcV
         02ATwkZHjCDo+zT76JPW6M7Y3F4PijAtw5va/sIQ3d1s4bRzcRtS6Sbqh+B4hFrXG8Ge
         qWFHxV0oyWX3RduoE5/tFoxavWRTmUp5pQyuBg11D8P6r1n0i7TRzNWJJ59nLnA9KerY
         1IUJvbXauH/MAdSPyD3NQ0PqcMTRlee1Vp9eLU783yYxAQwEQZ/52lH6z5cmJEAr+Tl2
         owDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=xoA9I9BIbFbMjr7xzglaSYMirU7cxPy7mUCKMopyv/Q=;
        b=PnIPIAClPVe6YIDOXrktkB9yAzF4F6Vbq3Pui2dF+YEBloxMAa7hPplu989zTCKdjz
         Hb3nQdz2RcEwUYI11nJUZIhnuo6nJFGtqmVDFOQcUnZGm2y2Z0B9pWgUjvAWS3StiXzO
         IgxGLtft/gErUc/4qdopQWcESqqsbM54uYTEjKsca2u2ZDxbKEasw9KRWWPLRarggZB4
         qOxnNxQ7HX0s8IovfrIEGCKO74lRBSpUdphvtBHOoFSoFRo5xg0pid4N3eVzp2tGx37D
         MSpldP4RA/JIf9uLgPZ3uG1Y8v5d/vKsS2WzvqfSwjJLz8bj+0WJ9qTUJejlIB9PYMvj
         N/jg==
X-Gm-Message-State: APjAAAXCpUiqu2f5w5k2c7GcxrFMdyRcpP473eVtagBt6HsH/U0nbN5d
        2RBG19iwtdkWgE/dHgRLUBALqTKq
X-Google-Smtp-Source: APXvYqziTyEsfQ6yb+IaF41URCGqN2H5ZEdjamLM19Vn3povpKf4jtg2ykxbKlf2yu5SVNvf5qWQOQ==
X-Received: by 2002:ae9:f50a:: with SMTP id o10mr15149843qkg.372.1571512817592;
        Sat, 19 Oct 2019 12:20:17 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id d23sm5197407qkc.127.2019.10.19.12.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 12:20:17 -0700 (PDT)
Date:   Sat, 19 Oct 2019 15:20:16 -0400
Message-ID: <20191019152016.GB3419791@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v4 1/2] net: dsa: Add support for devlink device
 parameters
In-Reply-To: <20191019185201.24980-2-andrew@lunn.ch>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Oct 2019 20:52:00 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> Add plumbing to allow DSA drivers to register parameters with devlink.
> 
> To keep with the abstraction, the DSA drivers pass the ds structure to
> these helpers, and the DSA core then translates that to the devlink
> structure associated to the device.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
