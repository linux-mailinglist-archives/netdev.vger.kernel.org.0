Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A6F8C9E9
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 05:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfHNDgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 23:36:08 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46948 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfHNDgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 23:36:08 -0400
Received: by mail-pl1-f196.google.com with SMTP id c2so50108749plz.13
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dXz61xkc+BVNj0H9DTtkS5LaH5FkL3Yi2V/d2G7sipg=;
        b=TSEihD07zGf41KNhiGldDphMCH8ZlJVe4ClQObGv7r6Ww4uyhbljTe8D3T9xXAqmJ2
         hPe+psKCBApttQ7GcxNr6e/NmDyBw+WsYmgjnKLp36ybu6DoeIlovz2d9rsNcnu8df3Q
         wr7XPI0dPYuWlGvejl8NWmPjT5fh7E9edvAswvsiG2FlHQwMFRyu5NeR3M8djT9GxKB2
         s3Afaie9mXsu8kOqc0soyeXZJGizdNQqAR5LFXzT1QIm7Fw+oDpWflTkQuijt8v5Jfi3
         OOMqc74VlIXbUq3+szkHGdFGm1xbHDtYugfwynFBOwhMXLLxpQNxEwP7l/L1c4+EoGgn
         KH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dXz61xkc+BVNj0H9DTtkS5LaH5FkL3Yi2V/d2G7sipg=;
        b=ag4pOyyyWJo4FC2ZCBnosN5PoyHlDCYjmrPo+2WQfcivsHbCKRjiecpmKJup9lA55y
         z3Qc7dBggoPp7vgNTfCXSVAY4X3xFhcOTcOnecPq+gItD0OLqPRa8vbbxhRS2VXn66Xf
         VzvQuxA4vX0OvvezTABsVwJ0rGiB2vQ8KFJfk+9IA5TgKMaD0Y3OmI8AQTeZgDPF7m8s
         04WRYJCrj2PgBtGurp0kAdp2m5rwON6d+2TjC5gkVK9oWQ8+g5+moYXAdrx5teJPS742
         hnA2nL3MbCBpt6/LYMMBo8y25ixpmx2FdDhD6jQBOLXHQCg4+NlYp4KV98utJaxVMDH+
         yrsg==
X-Gm-Message-State: APjAAAUzEIblx5ZsgSWuPJKZQXbGeawq7ZIJU+VXG9Y7HK6tF4d1GVWd
        jdaMkPSPALJquIjnkrtYC9JOQrCBmDQ95Q==
X-Google-Smtp-Source: APXvYqyYlsYzWTUZQTwixi4wlYAcUO634JDYSCmsLwjNCuwuNXTfOmCfA7622UQBmzzPvnBngXnspQ==
X-Received: by 2002:a17:902:f81:: with SMTP id 1mr40351498plz.191.1565753767968;
        Tue, 13 Aug 2019 20:36:07 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j15sm108914916pfr.146.2019.08.13.20.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 20:36:07 -0700 (PDT)
Date:   Wed, 14 Aug 2019 11:35:57 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, joe@perches.com
Subject: Re: [PATCH net v2] ibmveth: Convert multicast list size for
 little-endian system
Message-ID: <20190814033557.GW18865@dhcp-12-139.nay.redhat.com>
References: <1565644386-22284-1-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565644386-22284-1-git-send-email-tlfalcon@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 04:13:06PM -0500, Thomas Falcon wrote:
> The ibm,mac-address-filters property defines the maximum number of
> addresses the hypervisor's multicast filter list can support. It is
> encoded as a big-endian integer in the OF device tree, but the virtual
> ethernet driver does not convert it for use by little-endian systems.
> As a result, the driver is not behaving as it should on affected systems
> when a large number of multicast addresses are assigned to the device.
> 
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Thanks, I tested and it works good.
