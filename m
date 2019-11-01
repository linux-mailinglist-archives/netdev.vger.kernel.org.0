Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C03EEC854
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 19:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKASPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 14:15:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38821 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKASPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 14:15:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id v9so10479515wrq.5
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 11:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DaF/fN8ohwgwUWkK8En+70QBPGXgnEWmIV9bvJcYsGw=;
        b=2S1M79vFdbXz9S+tocHSJzFBdka0QHGa+4GkHJg//hWg706Vo5rD9oenQfOtaSmAUr
         Nk+Xd4+m+4czttRqQqXSum8FZZ65QDDeTkUjrFOxlHkLQTzGj+cUrk1h1XuuvMmLFRcc
         lEXLOwGtliJMr9WIAPTkQcoyZ81IW7MhYB0BuJkeOLkw4/BkQfLckT0irJmjcQsomzLU
         +GPO09k2Ymz5woSHeDQczPGhUFi9SEGe9bJ28Tf2qL+m6bC+0xAoBsx312A5mTCrVzIy
         2AWuzg55SbyWLaQYh1BblY4f5/tV6fADaOazrHHe9CLV7L+buzkjGGWoCphBpoUFkJG/
         H3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DaF/fN8ohwgwUWkK8En+70QBPGXgnEWmIV9bvJcYsGw=;
        b=cTm+CFaumREcx7higkRAtUVaEhTmL55xf3wIUd+cf9XYBrKYvlBWIW8hGHrrpppzZe
         YBeMNgcU1bJFn/mKyf3xwWcYSEUPAvYiMSqbk2Da94yqOB/iVLPa+LOq8TkAEpnez6Zn
         TOFMIin70hm/2RAVetJWCgeKK4xlMl/7vuxtiln8DFsDuzWRgGuAdTRpNSTtjtQn1bVl
         ZcsoPvJ/wrr6GxbrsP9beifpF7o1EHZ1ivyxC7P06QLYW3O1Jv7JEavMPifa181tmSK0
         CJqaLeYqIRd/FwtDZy9dRjdyqq7BVPjEJSGzeSW2rPy4ug/VKw9eU/bw5tGDeB5pMADb
         TV7g==
X-Gm-Message-State: APjAAAXnt6DUZ/95Z0nqtLOPdmwpw0wfwXlZr6IaRh39DG47sha+VjDn
        qlvnsWGILKkrhx2nWS6CV3FcWw==
X-Google-Smtp-Source: APXvYqynjkno+tQJc/BZhuPrx+2HgsQ9d+fnoevBPdLgerZmbfcvhXVkLbrgtMikjKc41AEYKJVkQg==
X-Received: by 2002:adf:f4c9:: with SMTP id h9mr7333981wrp.354.1572632122919;
        Fri, 01 Nov 2019 11:15:22 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id v6sm2006297wrt.13.2019.11.01.11.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 11:15:22 -0700 (PDT)
Date:   Fri, 1 Nov 2019 19:15:21 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: davinci-mdio: convert bindings to
 json-schema
Message-ID: <20191101181520.GC5859@netronome.com>
References: <20191101164502.19089-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101164502.19089-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 01, 2019 at 06:45:02PM +0200, Grygorii Strashko wrote:
> Now that we have the DT validation in place, let's convert the device tree
> bindings for the TI SoC Davinci/OMAP/Keystone2 MDIO Controllerr over to a
> YAML schemas.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>
