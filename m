Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9F84F24A4
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 09:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiDEHZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 03:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiDEHZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 03:25:06 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB826543
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 00:23:05 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id c42so6376190edf.3
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 00:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=+8o8z5eAjLzoYYRvcyTFAdvRMOxVZDs+vsqJse2i6K8=;
        b=Y5/3UhaHntNXfB2TN4ZFHBeoH7NHgcGpTBvw1CDMino9u74zFb7p+n/AYkI5T3TzzM
         c8IyXxav15nxKvzaW8lxlIeT2aWt7xmn50foWzvXIPsDm72fgvkEgutX2Fv7vuUWZLcK
         2df8ytRflytA49ox9FZbr04iHoJWNC1JU0T3wJjPJM4MjnwSgTguSDSmfdgkGbRmkqQm
         ITXlzLboQQMQ8CfG78FNhSqZFVQ8I3o1dT6NIEOdeynGDgcqNGuo01n1I0OYVmFzm/tM
         5+50j0VZUFkKXUoLKI/86JPQfhUNOEcTrWa17daDZbrWiayeZDO5H5MFJaMsct7JUf4V
         WSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+8o8z5eAjLzoYYRvcyTFAdvRMOxVZDs+vsqJse2i6K8=;
        b=kT+cQV7LfSQhF5wZh9rDmMxu384vQvlGBQ/LfxGFqRlhNcQl2xhRtTTwPdHbrwhRxZ
         QEKE9L1h0t0SPeqZDRPwI5xnlBGm7N0WPg6QdvxLr/blwjXU5SpFqyoqDsNuxTI5S/ay
         zVmP2Wy1yeLtOMjDDSGweeO+Lw0cT8r9MVYllSvzbveageZkGZUjuxhZi4ZZT6E8k/ey
         FIU2d7+8Fr0GIwtVaohd/fC4JHIm4AVJUpkPzvryIExdyeI5JlcYeU4vvLGGTDbZeM2C
         ejrLYSSUSOb3Sl6blukUSQ/V2Hin1CoTS9CZwfyVngCF0E/QhBXurCcfgM6ZkMzKAUXG
         8dag==
X-Gm-Message-State: AOAM530AEy0M1GjHqAJJI812ZzNzlbQ6BtfwLJZfCSLPozZYENsUz+vB
        Y4skYa/6p0+pcuTnmSHTQ5V+egRTj24576YvY0k=
X-Google-Smtp-Source: ABdhPJxszRfb4MAH+uRd8PDmlTXfLlXkLh3f6uRbdWkZbR4uEU9HGWYcTJVRXAETr72FGznghHf2knvK56APV21QgOw=
X-Received: by 2002:a05:6402:4414:b0:419:28bc:55dc with SMTP id
 y20-20020a056402441400b0041928bc55dcmr2203578eda.130.1649143384192; Tue, 05
 Apr 2022 00:23:04 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Tue, 5 Apr 2022 08:22:53 +0100
Message-ID: <CAHpNFcO+WoN1A1uHuoV2YhgiZnLkiddw3_D8nLA4LygTZWU7Gw@mail.gmail.com>
Subject: Secure-Enable PSP + SGX + Initiator Security Virtualise 2022 : Self
 Tests & Thread control pages *Kernel Base L1:L2,L3:Cache MontiCarlos
 Processor Feature & Task Manger*
To:     torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Secure-Enable PSP + SGX + Initiator Security Virtualise 2022

Proper initiation requires at least a basic permission statement
before kernel load:RS

<VMaWare Initiator>
Firmware, bios load <init>1 }
Boot Loader <init>2         } Enclave 1
Kernel Jack on safe boot <init>3 : Enclave 2
Core Modules <init>4 Enclave 3
System <init><init><init><init><init>

(c)Rupert S https://bit.ly/VESA_BT

> > + * Some 'Enable PSP + SGX' functions require that no cached linear-to-physical address
> > + * mappings are present before they can succeed. Collaborate with
> > + * hardware via ENCLS[ETRACK] to ensure that all cached
> > + * linear-to-physical address mappings belonging to all threads of
> > + * the enclave are cleared. See sgx_encl_cpumask() for details.

Cache Buffer can hide locations from direct attack! <VIRUALISE LOC>
But do involve a potential page break if not aligned

> > + * Return valid permission fields from a secinfo structure provided by
> > + * user space. The secinfo structure is required to only have bits in
> > + * the permission fields set.

Virtualise buffer can lazy IO & Lazy DMA #Thread mate DT

> > + * Ensure enclave is ready for SGX2 functions. Readiness is checked
> > + * by ensuring the hardware supports SGX2 and the enclave is initialized
> > + * and thus able to handle requests to modify pages within it.

Boot time check can validate SGX & PSP & YES Cache a relocatable table,
Direct Read required INT & IO Activations & is not Cache permitted one
presumes. DT

> > Changes since V2:
> > - Include the sgx_ioc_sgx2_ready() utility
> >   that previously was in "x86/sgx: Support relaxing of enclave page
> >   permissions" that is removed from the next version.
> > - Few renames requested >

Broken Alignment DT
Separated BASE Code DT

Strict Code Align =1
Buffer RELOC = 1
Security permission Buffer = 751

Enable PSP + SGX

https://lkml.org/lkml/2022/4/5/29
https://lkml.org/lkml/2022/4/5/27
https://lkml.org/lkml/2022/4/5/25

https://lkml.org/lkml/2022/4/5/50

https://lkml.org/lkml/2022/4/4/982

Self Tests & Thread control pages *Kernel Base L1:L2,L3:Cache
MontiCarlos Processor Feature & Task Manger* >> Reference :
https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

https://lkml.org/lkml/2022/4/5/119
https://lkml.org/lkml/2022/4/5/120
https://lkml.org/lkml/2022/4/5/121
https://lkml.org/lkml/2022/4/5/122
https://lkml.org/lkml/2022/4/5/123
https://lkml.org/lkml/2022/4/5/125
https://lkml.org/lkml/2022/4/5/127
https://lkml.org/lkml/2022/4/5/128
https://lkml.org/lkml/2022/4/5/129
https://lkml.org/lkml/2022/4/5/130

<< Self Tests & Thread control pages *Kernel Base L1:L2,L3:Cache
MontiCarlos Processor Feature & Task Manger*

*

https://science.n-helix.com/2018/12/rng.html

https://science.n-helix.com/2022/02/rdseed.html

https://science.n-helix.com/2017/04/rng-and-random-web.html

https://science.n-helix.com/2022/02/interrupt-entropy.html

https://science.n-helix.com/2021/11/monticarlo-workload-selector.html

https://science.n-helix.com/2022/03/security-aspect-leaf-hash-identifiers.html


Audio, Visual & Bluetooth & Headset & mobile developments only go so far:

https://science.n-helix.com/2022/02/visual-acuity-of-eye-replacements.html

https://science.n-helix.com/2022/03/ice-ssrtp.html

https://science.n-helix.com/2021/11/ihmtes.html

https://science.n-helix.com/2021/10/eccd-vr-3datmos-enhanced-codec.html
https://science.n-helix.com/2021/11/wave-focus-anc.html
https://science.n-helix.com/2021/12/3d-audio-plugin.html
