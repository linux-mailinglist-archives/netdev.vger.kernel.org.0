Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E7E13C29
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 23:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfEDV01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 17:26:27 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36187 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbfEDV01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 17:26:27 -0400
Received: by mail-qt1-f194.google.com with SMTP id c35so10723701qtk.3
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 14:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=JF831zpKvCseUbXHlyEmJnKk00e1INt9oW+7TWi7V4w=;
        b=M4eewVtlYoC+vHdQf1DZ97gzZs96FTgChVEADFL2eCdFATLHU8NANWe3hY0hKhkl1i
         3f7K/XciVYWoZd/zE7yvJFzdMOFKaRRd3raCIPlFYrv49ukRnowoIxlcj8vC+gaGvL35
         s5nmpeEd5JWqCcddn+fA/0qXZpx+WPQyz/zyCDHxbb/oQ/v4c0++68vrAWW/ZhFDhZEk
         fGHAjmrFzAtOf6fgkiCsy6BhQpf8JclmcWKzbSVDdNaR0N6231JL31AMvmKE69xhKjjM
         R5JwqLY3tDvq4ws1lziAGcUyyijvb3qHkS1IDPijnWRbPOk+LrmJknH2wQ97r2TEEhZN
         Mcew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=JF831zpKvCseUbXHlyEmJnKk00e1INt9oW+7TWi7V4w=;
        b=hrLRs1VJmfjOq6alYLtjdxebiFgt07tnooGCGUebf2rKpvXNuD/iPkge/mJttohaO7
         o6TN/byGZjJpv4/R1C+YW3vl7cHcdtPav+MQV1qdN71TXRqUA6roi9D+/unyRMnwKOM/
         tZIThyC5GdopzQ3CcfW4+apy4BqV79zT5vxrdF1VyULdZULUjl3XFjsQl5sOY5Akabav
         EeLayofdeQVZ0row/Y0Ofzmz3j4MX7KFzr8oKCWymaSviRNDKGlt5Avt4PbhTnQ0ycJs
         W6O6TVx81nE4lzVR5xWvHD2FdGQn4TNbuRwG75xtbMtB/2sFtVx+5X/YC5jqD2MQENeN
         YvkQ==
X-Gm-Message-State: APjAAAVSVln94M3DrO5Cn/6T1N40zvoHRNfj6X7MZiKs6Ql7gLW8GnmG
        N2FFNj4ANkkkqA3NUFwcRe8=
X-Google-Smtp-Source: APXvYqxo6WwHCizvyUEpwGQ6UjRKhk/UkGLN7G2ahURjoosyp1mMR807jbuFEdrcWZQ4NPRdY+5pAw==
X-Received: by 2002:ad4:4591:: with SMTP id x17mr797331qvu.34.1557005186463;
        Sat, 04 May 2019 14:26:26 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id k190sm3299107qkd.28.2019.05.04.14.26.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 14:26:25 -0700 (PDT)
Date:   Sat, 4 May 2019 17:26:24 -0400
Message-ID: <20190504172624.GB25185@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 6/9] net: dsa: Add a private structure pointer
 to dsa_port
In-Reply-To: <20190504135919.23185-7-olteanv@gmail.com>
References: <20190504135919.23185-1-olteanv@gmail.com>
 <20190504135919.23185-7-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 May 2019 16:59:16 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> This is supposed to share information between the driver and the tagger,
> or used by the tagger to keep some state. Its use is optional.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
