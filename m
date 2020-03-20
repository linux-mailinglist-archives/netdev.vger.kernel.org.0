Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6368718D15B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 15:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgCTOoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 10:44:39 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35510 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgCTOoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 10:44:39 -0400
Received: by mail-lj1-f194.google.com with SMTP id u12so6706825ljo.2
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 07:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:originalfrom:original:in-reply-to
         :originaldate:date:cc:subject:from:to:message-id;
        bh=vFYZWc5b7NagoyG2ImwAyIlhi4HOlWR9kM9LZwUkyP0=;
        b=dxpIJDp/ldiUS5mUFT4xq7OuE+md0/6i75K8aWcqimVmUwEv93ZXTANVrTdHqhtupT
         SLnZfWTJ4CxEVLv5D0kBr+tHw7YmKM7pbjNeQnCb3OZ6m8HimYAQjBNoJFqOp9Va2z86
         FO3RR5ahOvnPUkkaM1QjiyZkFHeqbKbM/x5xJWvsVFJdk8QjZdYaM4oSKgB1yeArrsyI
         +CdlFshAT15IrG3SRi5krKdS8JtwdbRrwsYwbm6Xp0RrFGe91CSknWjs7WrgNUcjzOLU
         LOySJuixa+LGtSIq+iQ5VCe88PPDgLS4UY4FXXWLlcRDxM66asf0ySWqnVXEDMRGEoPF
         tW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:originalfrom:original
         :in-reply-to:originaldate:date:cc:subject:from:to:message-id;
        bh=vFYZWc5b7NagoyG2ImwAyIlhi4HOlWR9kM9LZwUkyP0=;
        b=iCRZN+pG7/WhmyDyQmwRmb+UZoQcbm7ZxZ2j8OFQICkvGCkLNoIUQ0524Ib6vfL3A6
         gADBXWZBq4uhMExM3YS7NMXPoT+pLemygdjtMwLfzW9AQE+gaXKUhtA7JJ61M2w4JnBx
         MMfEObmKSJ8UjgHZeA7Ge/t1YrIPleFK16DaPAgv5hGQiB31LpxgJ/JEyE509zWNa4vs
         EK02vno8X7Sp+nB1NHvRqaBxkZC9y2Vox8yyySiWWlxeyKEsGI2/GcQiGaY4KHEHwhAx
         vKUlyj98GDGwNG8yPCV2I5iBEQEoCCZwIpgoCk2poCYtQzCOqCeBcl/roIAM4/EKK3+G
         2MpQ==
X-Gm-Message-State: ANhLgQ3wY45XrRTDI5eReDoEh29s0lDoq9hi9iTfw+b2pYBV5UT9KdVl
        w7sdRK3cjqmfAjNwNI4Kixfb/LdCv0RPUw==
X-Google-Smtp-Source: ADFU+vtn6/Aoft7mAAo/JTkA38XL9jsgafRQlw3yFKaF6sj3UXgBgn4IGycebrk4mfWK/Hfpszz6AA==
X-Received: by 2002:a2e:8699:: with SMTP id l25mr5384913lji.148.1584715476106;
        Fri, 20 Mar 2020 07:44:36 -0700 (PDT)
Received: from localhost (h-50-180.A259.priv.bahnhof.se. [155.4.50.180])
        by smtp.gmail.com with ESMTPSA id i190sm1815839lfi.7.2020.03.20.07.44.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Mar 2020 07:44:35 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Originalfrom: "Andrew Lunn" <andrew@lunn.ch>
Original: =?utf-8?q?Hi_Tobias=0D=0A=0D=0A>_How_about_just_mdio-mvusb
 =3F=0D=0A=0D=0A?= =?utf-8?q?Yes,_i_like_that.
 =0D=0A=0D=0A>_On_the_88E6390X-DB,_I_know_that_?=
 =?utf-8?q?there_is_a_chip_by_the_USB_port_that=0D=0A>_is_probably_either_?=
 =?utf-8?q?an_MCU_or_a_small_FPGA._I_can_have_a_closer_look_at=0D=0A>_it_w?=
 =?utf-8?q?hen_I'm_at_the_office_tomorrow_if_you'd_like._I_also_remember?=
 =?utf-8?q?=0D=0A>_seeing_some_docs_from_Marvell_which_seemed_to_indicate_?=
 =?utf-8?q?that_they_have=0D=0A>_a_standalone_product_providing_only_the_U?=
 =?utf-8?q?SB-to-MDIO_functionality.=0D=0A=0D=0AI_would_be_interested_in_k?=
 =?utf-8?q?nowing_more.=0D=0A=0D=0A>_The_x86_use-case_is_interesting._It_w?=
 =?utf-8?q?ould_be_even_more_so_if_there_was=0D=0A>_some_way_of_loading_a_?=
 =?utf-8?q?DSA_DT_fragment_so_that_you_could_hook_it_up_to=0D=0A>_your_mac?=
 =?utf-8?q?hine's_Ethernet_port.=0D=0A=0D=0AWe_don't_have_that_at_the_mome?=
 =?utf-8?q?nt._But_so_long_as_you_only_need=0D=0Ainternal_copper_PHYs,_it_?=
 =?utf-8?q?is_possible_to_use_a_platform_device_and_it=0D=0Aall_just_works?=
 =?utf-8?q?.=0D=0A=0D=0A>_>_>_+static_int_smi2usb=5Fprobe(struct_usb=5Fint?=
 =?utf-8?q?erface_*interface,=0D=0A>_>_>_+=09=09=09_const_struct_usb=5Fdev?=
 =?utf-8?q?ice=5Fid_*id)=0D=0A>_>_>_+{=0D=0A>_>_>_+=09struct_device_*dev_?=
 =?utf-8?q?=3D_&interface->dev;=0D=0A>_>_>_+=09struct_mii=5Fbus_*mdio;=0D?=
 =?utf-8?q?=0A>_>_>_+=09struct_smi2usb_*smi;=0D=0A>_>_>_+=09int_err_=3D_-E?=
 =?utf-8?q?NOMEM;=0D=0A>_>_>_+=0D=0A>_>_>_+=09mdio_=3D_devm=5Fmdiobus=5Fal?=
 =?utf-8?q?loc=5Fsize(dev,_sizeof(*smi));=0D=0A>_>_>_+=09if_(!mdio)=0D=0A>?=
 =?utf-8?q?_>_>_+=09=09goto_err;=0D=0A>_>_>_+=0D=0A>_>_=0D=0A>_>_...=0D=0A?=
 =?utf-8?q?>_>_=0D=0A>_>_=0D=0A>_>_>_+static_void_smi2usb=5Fdisconnect(str?=
 =?utf-8?q?uct_usb=5Finterface_*interface)=0D=0A>_>_>_+{=0D=0A>_>_>_+=09st?=
 =?utf-8?q?ruct_smi2usb_*smi;=0D=0A>_>_>_+=0D=0A>_>_>_+=09smi_=3D_usb=5Fge?=
 =?utf-8?q?t=5Fintfdata(interface);=0D=0A>_>_>_+=09mdiobus=5Funregister(sm?=
 =?utf-8?q?i->mdio);=0D=0A>_>_>_+=09usb=5Fset=5Fintfdata(interface,_NULL);?=
 =?utf-8?q?=0D=0A>_>_>_+=0D=0A>_>_>_+=09usb=5Fput=5Fintf(interface);=0D=0A?=
 =?utf-8?q?>_>_>_+=09usb=5Fput=5Fdev(interface=5Fto=5Fusbdev(interface));?=
 =?utf-8?q?=0D=0A>_>_>_+}=0D=0A>_>_=0D=0A>_>_I_don't_know_enough_about_USB?=
 =?utf-8?q?._Does_disconnect_have_the_same_semantics=0D=0A>_>_remove()=3F_?=
 =?utf-8?q?You_used_devm=5Fmdiobus=5Falloc=5Fsize()_to_allocate_the_bus=0D?=
 =?utf-8?q?=0A>_>_structure._Will_it_get_freed_after_disconnect=3F_I've_ha?=
 =?utf-8?q?d_USB_devices=0D=0A>_>_connected_via_flaky_USB_hubs_and_they_ha?=
 =?utf-8?q?ve_repeatedly_disappeared_and=0D=0A>_>_reappeared._I_wonder_if_?=
 =?utf-8?q?in_that_case_you_are_leaking_memory_if=0D=0A>_>_disconnect_does?=
 =?utf-8?q?_not_release_the_memory=3F=0D=0A>_=0D=0A>_Disclaimer:_This_is_m?=
 =?utf-8?q?y_first_ever_USB_driver.=0D=0A=0D=0AAnd_i've_only_ever_written_?=
 =?utf-8?q?one_which_has_been_merged.=0D=0A=0D=0A>_I_assumed_that_since_we?=
 =?utf-8?q?'re_removing_'interface',_'interface->dev'_will=0D=0A>_be_remov?=
 =?utf-8?q?ed_as_well_and_thus_calling_all_devm_hooks.=0D=0A>_=0D=0A>_>_>_?=
 =?utf-8?q?+=09usb=5Fput=5Fintf(interface);=0D=0A>_>_>_+=09usb=5Fput=5Fdev?=
 =?utf-8?q?(interface=5Fto=5Fusbdev(interface));=0D=0A>_>_>_+}=0D=0A>_>_?=
 =?utf-8?q?=0D=0A>_>_Another_USB_novice_question._Is_this_safe=3F_Could_th?=
 =?utf-8?q?e_put_of_interface=0D=0A>_>_cause_it_to_be_destroyed=3F_Then_in?=
 =?utf-8?q?terface=5Fto=5Fusbdev()_is_called_on=0D=0A>_>_invalid_memory=3F?=
 =?utf-8?q?=0D=0A>_=0D=0A>_That_does_indeed_look_scary._I_inverted_the_ord?=
 =?utf-8?q?er_of_the_calls_to_the=0D=0A>_=5Fget=5F_functions,_which_I_got_?=
 =?utf-8?q?from_the_USB_skeleton_driver._I'll_try_to=0D=0A>_review_some_ot?=
 =?utf-8?q?her_drivers_to_see_if_I_can_figure_this_out.=0D=0A>_=0D=0A>_>_M?=
 =?utf-8?q?aybe_this_should_be_cross_posted_to_a_USB_mailing_list,_so_we_c?=
 =?utf-8?q?an_get=0D=0A>_>_the_USB_aspects_reviewed._The_MDIO_bits_seem_go?=
 =?utf-8?q?od_to_me.=0D=0A>_=0D=0A>_Good_idea._Any_chance_you_can_help_an_?=
 =?utf-8?q?LKML_rookie_out=3F_How_does_one_go=0D=0A>_about_that=3F_Do_I_si?=
 =?utf-8?q?mply_reply_to_this_thread_and_add_the_USB_list,_or=0D=0A>_do_I_?=
 =?utf-8?q?post_the_patches_again_as_a_new_series=3F_Any_special_tags=3F_I?=
 =?utf-8?q?s=0D=0A>_there_any_documentation_available=3F=0D=0A=0D=0AI_woul?=
 =?utf-8?q?d_fixup_the_naming_and_repost._You_can_put_whatever_comments_yo?=
 =?utf-8?q?u=0D=0Awant_under_the_---_marker._So_say_this_driver_should_be_?=
 =?utf-8?q?merged_via=0D=0Anetdev,_but_you_would_appreciate_reviews_of_the?=
 =?utf-8?q?_USB_parts_from_USB=0D=0Amaintainers._linux-usb@vger.kernel.org?=
 =?utf-8?q?_would_be_the_correct_list_to=0D=0Aadd.=0D=0A=0D=0A_____Andrew?=
 =?utf-8?q?=0D=0A?=
In-Reply-To: <20200319230002.GO27807@lunn.ch>
Originaldate: Fri Mar 20, 2020 at 12:00 AM
Date:   Fri, 20 Mar 2020 15:44:34 +0100
Cc:     <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] net: phy: marvell smi2usb mdio controller
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Andrew Lunn" <andrew@lunn.ch>
Message-Id: <C1FQR2V46F7K.1KBCJSQ8V4V2B@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> > How about just mdio-mvusb?
>
>=20
> Yes, i like that.

ACK.

> > On the 88E6390X-DB, I know that there is a chip by the USB port that
> > is probably either an MCU or a small FPGA. I can have a closer look at
> > it when I'm at the office tomorrow if you'd like. I also remember
> > seeing some docs from Marvell which seemed to indicate that they have
> > a standalone product providing only the USB-to-MDIO functionality.
>
>=20
> I would be interested in knowing more.

It seems like they are using the Cypress FX2 controller
(CY7C68013). I've used it before on USB device projects. If I remember
correctly it has an 8052 core, a USB2 controller and some low-speed
I/O blocks. Couldn't locate the slide deck about a standalone device
unfortunately.

> I would fixup the naming and repost. You can put whatever comments you
> want under the --- marker. So say this driver should be merged via
> netdev, but you would appreciate reviews of the USB parts from USB
> maintainers. linux-usb@vger.kernel.org would be the correct list to
> add.

Great. Just to make sure I've understood: I'll send v3 with _both_
netdev and linux-usb in "To:"?

Thanks,
wkz
