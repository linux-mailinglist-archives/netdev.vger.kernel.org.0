Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3002C912C4
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfHQTu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:50:28 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45637 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfHQTu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 15:50:28 -0400
Received: by mail-qt1-f195.google.com with SMTP id k13so9859601qtm.12
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 12:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=sm4nToAbYJOafdKg59Dscfz4sZQmcC7i5LpU779cRwE=;
        b=E628a+KZmhiCKeB/yTXEL/PP1/bzPwiVBf4ejZxqJm0f8bb/L1XghH/qDpD8EeN2d/
         cDUtfUxFJNubIe1D7PS7jmYyfFoJ6spoJh+iLpcc/qxTUBGzdfqblwGd10SyAX2y7WHR
         AJP6FU3DlxPmPqZ0NHjhsPX9xL5tu2GRBH41Fjdl+IyFQ0dvyfxOjHge8jjAoz9fHyix
         SkmJUOzYspnSdQepa1TZNMLOadBiY0G4b5RhfJ3j8rlHft0I8en6hqx9WCalkHDTJDV4
         HBPaTsXNWZWZv7WhhLpIfT3Du3xlrSr8nMZu1BtQv81+lhbxSd5i/VFlo7AI9mLgm2ke
         QRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=sm4nToAbYJOafdKg59Dscfz4sZQmcC7i5LpU779cRwE=;
        b=p6iIWirE9sW7opzeo7vNihhmIcnX8TrKutyyrmVSBPOrD5qteDwTIbxQx1cm1C2xeH
         65sZ7usrbnv7raF7KvilzT6bsxAJ0D2WUGuKGycKwspLhdvLCmq6c36/1Sk+m9miLDa8
         hP1wzP0/R0pRj9sMliAs9pYdP6oBgW/E8IhL1pvEeldvUpAY1XE/nieRXG7wQpmMyEbW
         CHVwewsONo3E1d51hjz1AUWUIs4XaSyMaQkjjkV0pP+3B1Pb1bhT28722zZyOxjce4yq
         5xoMIzdbTdOf5hjurqBbYP4jFQgRj2J1ElhRyvgV7nq4DCAthRXe6wovWkEyuJl2BlPp
         Hk1A==
X-Gm-Message-State: APjAAAXqhAmXnwZ45qTDRe/cq4miPNPDrKFY+y4xqj8xPmsNzjewB8/n
        nFK/7DDRJX87csXggniO9Q4=
X-Google-Smtp-Source: APXvYqzFSjr4mQ7tXMIss5zygo+dj7XIgDjUyItcuRcOnsXAYsJkukMg1fy6covFzQ0SUoHKQZFJnA==
X-Received: by 2002:ac8:70d1:: with SMTP id g17mr14717531qtp.124.1566071427118;
        Sat, 17 Aug 2019 12:50:27 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id s3sm2449784qkc.57.2019.08.17.12.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Aug 2019 12:50:26 -0700 (PDT)
Date:   Sat, 17 Aug 2019 15:50:25 -0400
Message-ID: <20190817155025.GB9013@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
Subject: Re: [PATCH RFC v2 net-next 0/4] mv88e6xxx: setting 2500base-x mode
 for CPU/DSA port in dts
In-Reply-To: <20190817191452.16716-1-marek.behun@nic.cz>
References: <20190817191452.16716-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sat, 17 Aug 2019 21:14:48 +0200, Marek Behún <marek.behun@nic.cz> wrote:
> Hi,
> 
> here is another proposal for supporting setting 2500base-x mode for
> CPU/DSA ports in device tree correctly.
> 
> The changes from v1 are that instead of adding .port_setup() and
> .port_teardown() methods to the DSA operations struct we instead, for
> CPU/DSA ports, call dsa_port_enable() from dsa_port_setup(), but only
> after the port is registered (and required phylink/devlink structures
> exist).
> 
> The .port_enable/.port_disable methods are now only meant to be used
> for user ports, when the slave interface is brought up/down. This
> proposal changes that in such a way that these methods are also called
> for CPU/DSA ports, but only just after the switch is set up (and just
> before the switch is tore down).
> 
> If we went this way, we would have to patch the other DSA drivers to
> check if user port is being given in their respective .port_enable
> and .port_disable implmentations.
> 
> What do you think about this?

This looks much better. Let me pass through all patches of this RFC so that
I can include bits I would like to see in your next series.


Thanks,

	Vivien
