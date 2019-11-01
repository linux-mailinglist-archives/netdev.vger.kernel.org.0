Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353E2EC856
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 19:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKASQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 14:16:06 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52743 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfKASQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 14:16:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id c17so2816448wmk.2
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 11:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sxZpbgKRxXNWGi7JPE5PJWysYsru4FyBDVNdoORRq6s=;
        b=vttfE+yHueTydpOmGzXppeugfpRtDd2BWsq3YaVtIJ2Z0/Tokkp5mPQ7DMvO06zg5S
         Tk4b1yFEhm2Wc5Z0iMzxyARZGJFr0ZwreXVX7yJsX52sKOP4mKT6zJqPUuEj3q72e/qN
         zdgumdE0Dm8GOejq+pRy0oH9hv0NvzIaN9Eql4dQdJh7MFWEPiST+yyb3rh84kZdjAzy
         Lbl9fdSGQ+heCbTnoNhbbjIn3AxlP6cIHb2UG61hvDkl/mO7rICswVRgJzGZWHiMFVe/
         FDfcz4U8pQrhGgrUiPI0OQJkH0yZ1KDSH5NSgbbe7oXPcIDEf2eGdTGHV/3anZOfyOB2
         v5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sxZpbgKRxXNWGi7JPE5PJWysYsru4FyBDVNdoORRq6s=;
        b=mPSmGt4yYd4pBteJN7xRGHbY3v9c6GHHpcFepJBrwgg01RQZTqpNqWBV4LXh/vOLbc
         1V2cPV3nsACX80+YXk6uV7XGxflVsNl0G6GYrmatGT3txVc2YIcODFC4Lnf22XyyUEka
         F22Y8C5PeI8PPDNlRZhDByz+MO51sHBmiar8a/pJtex75qLJu6EB/a0ul2i1jjBFshLB
         vMU5d1WDx4k4AxtBYXrzdQSMfltp4V+X2+VrubojNnaXDwhOH6RBubUUic3Lf/FM4UCu
         a0mm2lwhFFS2ki/uNJmgLDnXPz4p483rL+97kXktGQ579Vfe0XD2dyO469MHyg3t0AOn
         T0bw==
X-Gm-Message-State: APjAAAVBRUxPu+fqppyBFehk7Ya6VSYkltFq+IyG5AdpdmfDafV9J0wg
        ToIwun67mErz700p9UsEZzqnhg==
X-Google-Smtp-Source: APXvYqxissnymQlTIZHuchg7pdEDwKYW3/LTmbLmpkQZw7CfA6kNNHUqMixo6wErYI+CKsI4eGbAYw==
X-Received: by 2002:a1c:a791:: with SMTP id q139mr11147563wme.155.1572632162588;
        Fri, 01 Nov 2019 11:16:02 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id w13sm10336198wrm.8.2019.11.01.11.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 11:16:02 -0700 (PDT)
Date:   Fri, 1 Nov 2019 19:16:01 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     vincent.cheng.xh@renesas.com
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, richardcochran@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] dt-bindings: ptp: Add device tree binding for IDT
 ClockMatrix based PTP clock
Message-ID: <20191101181600.GD5859@netronome.com>
References: <1572578407-32532-1-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572578407-32532-1-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 11:20:06PM -0400, vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> Add device tree binding doc for the IDT ClockMatrix PTP clock.
> 
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

