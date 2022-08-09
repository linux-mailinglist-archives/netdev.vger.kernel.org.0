Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C94258E363
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiHIWpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiHIWpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:45:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859EB4F1BC;
        Tue,  9 Aug 2022 15:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14AF560F15;
        Tue,  9 Aug 2022 22:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DFCC433C1;
        Tue,  9 Aug 2022 22:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660085139;
        bh=hUlothYS42NbJx2EZQ1SQwFlmVbnc5L6p9uDuL4ag/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NTtRI0iiab/gC0oV2Y61h98jcEcFsgHmaYVujWPmQi2Y/PQJRt+CnDjuYElmyR97o
         xXKJIh7zU4s3KJyIWiDKjn1hn7P8Qf7HK89M51x6/FF0JVyvjkAJcbifEkorUiqHrB
         YaCU41GbhV/BxTUTdnnstwjw3jdJzyqQll30CqcnoZb+/5238OX6PEx54WojgkLE51
         6cjMWL5adxggldNs9bAMOVNaD7eNDKgIEZQsPVdrs7TeHvXd+PGGtChZab0n2r7Cc4
         XLIR5BPmaXLCmKVs3xE6KcoDUmlt6G5am8s0xy5bcK1PclokdvzccqAD7rUXBE0i+n
         jHGriTklfDjvQ==
Received: by pali.im (Postfix)
        id E8E7320B2; Wed, 10 Aug 2022 00:45:35 +0200 (CEST)
Date:   Wed, 10 Aug 2022 00:45:35 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Message-ID: <20220809224535.ymzzt6a4v756liwj@pali>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
 <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local>
 <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <20220809213146.m6a3kfex673pjtgq@pali>
 <b1b33912-8898-f42d-5f30-0ca050fccf9a@seco.com>
 <20220809214207.bd4o7yzloi4npzf7@pali>
 <2083d6d6-eecf-d651-6f4f-87769cd3d60d@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2083d6d6-eecf-d651-6f4f-87769cd3d60d@seco.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 09 August 2022 18:41:25 Sean Anderson wrote:
> 
> 
> On 8/9/22 5:42 PM, Pali Rohár wrote:
> > On Tuesday 09 August 2022 17:36:52 Sean Anderson wrote:
> >> On 8/9/22 5:31 PM, Pali Rohár wrote:
> >> > On Tuesday 09 August 2022 16:48:23 Sean Anderson wrote:
> >> >> On 8/8/22 5:45 PM, Michal Suchánek wrote:
> >> >> > On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wrote:
> >> >> >> On Mon, 8 Aug 2022 23:09:45 +0200
> >> >> >> Michal Suchánek <msuchanek@suse.de> wrote:
> >> >> >> 
> >> >> >> > On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
> >> >> >> > > Hi Tim,
> >> >> >> > > 
> >> >> >> > > On 8/8/22 3:18 PM, Tim Harvey wrote:  
> >> >> >> > > > Greetings,
> >> >> >> > > > 
> >> >> >> > > > I'm trying to understand if there is any implication of 'ethernet<n>'
> >> >> >> > > > aliases in Linux such as:
> >> >> >> > > >         aliases {
> >> >> >> > > >                 ethernet0 = &eqos;
> >> >> >> > > >                 ethernet1 = &fec;
> >> >> >> > > >                 ethernet2 = &lan1;
> >> >> >> > > >                 ethernet3 = &lan2;
> >> >> >> > > >                 ethernet4 = &lan3;
> >> >> >> > > >                 ethernet5 = &lan4;
> >> >> >> > > >                 ethernet6 = &lan5;
> >> >> >> > > >         };
> >> >> >> > > > 
> >> >> >> > > > I know U-Boot boards that use device-tree will use these aliases to
> >> >> >> > > > name the devices in U-Boot such that the device with alias 'ethernet0'
> >> >> >> > > > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
> >> >> >> > > > appears that the naming of network devices that are embedded (ie SoC)
> >> >> >> > > > vs enumerated (ie pci/usb) are always based on device registration
> >> >> >> > > > order which for static drivers depends on Makefile linking order and
> >> >> >> > > > has nothing to do with device-tree.
> >> >> >> > > > 
> >> >> >> > > > Is there currently any way to control network device naming in Linux
> >> >> >> > > > other than udev?  
> >> >> >> > > 
> >> >> >> > > You can also use systemd-networkd et al. (but that is the same kind of mechanism)
> >> >> >> > >   
> >> >> >> > > > Does Linux use the ethernet<n> aliases for anything at all?  
> >> >> >> > > 
> >> >> >> > > No :l  
> >> >> >> > 
> >> >> >> > Maybe it's a great opportunity for porting biosdevname to DT based
> >> >> >> > platforms ;-)
> >> >> >> 
> >> >> >> Sorry, biosdevname was wrong way to do things.
> >> >> >> Did you look at the internals, it was dumpster diving as root into BIOS.
> >> >> > 
> >> >> > When it's BIOS what defines the names then you have to read them from
> >> >> > the BIOS. Recently it was updated to use some sysfs file or whatver.
> >> >> > It's not like you would use any of that code with DT, anyway.
> >> >> > 
> >> >> >> Systemd-networkd does things in much more supportable manner using existing
> >> >> >> sysfs API's.
> >> >> > 
> >> >> > Which is a dumpster of systemd code, no thanks.
> >> >> > 
> >> >> > I want my device naming independent of the init system, especially if
> >> >> > it's systemd.
> >> >> 
> >> >> Well, there's always nameif...
> >> >> 
> >> >> That said, I have made [1] for people using systemd-networkd.
> >> >> 
> >> >> --Sean
> >> >> 
> >> >> [1] https://github.com/systemd/systemd/pull/24265
> >> > 
> >> > Hello!
> >> > 
> >> > In some cases "label" DT property can be used also as interface name.
> >> > For example this property is already used by DSA kernel driver.
> >> > 
> >> > I created very simple script which renames all interfaces in system to
> >> > their "label" DT property (if there is any defined).
> >> > 
> >> > #!/bin/sh
> >> > for iface in `ls /sys/class/net/`; do
> >> > 	for of_node in of_node device/of_node; do
> >> > 		if test -e /sys/class/net/$iface/$of_node/; then
> >> > 			label=`cat /sys/class/net/$iface/$of_node/label 2>/dev/null`
> >> > 			if test -n "$label" && test "$label" != "$iface"; then
> >> > 				echo "Renaming net interface $iface to $label..."
> >> > 				up=$((`cat /sys/class/net/$iface/flags 2>/dev/null || echo 1` & 0x1))
> >> > 				if test "$up" != "0"; then
> >> > 					ip link set dev $iface down
> >> > 				fi
> >> > 				ip link set dev $iface name "$label" && iface=$label
> >> > 				if test "$up" != "0"; then
> >> > 					ip link set dev $iface up
> >> > 				fi
> >> > 			fi
> >> > 			break
> >> > 		fi
> >> > 	done
> >> > done
> >> > 
> >> > Maybe it would be better first to use "label" and then use ethernet alias?
> >> > 
> >> 
> >> It looks like there is already precedent for using ID_NET_LABEL_ONBOARD for
> >> this purpose (on SMBios boards). It should be a fairly simple extension to
> >> add that as well. However, I didn't find any uses of this in Linux or U-Boot
> >> (although I did find plenty of ethernet LEDs). Do you have an example you
> >> could point me to?
> >> 
> >> --Sean
> > 
> > In linux:
> > $ git grep '"label"' net/dsa/dsa2.c
> > net/dsa/dsa2.c: const char *name = of_get_property(dn, "label", NULL);
> > 
> 
> Hm, if Linux is using the label, then do we need to rename things in userspace?

It uses it _only_ for DSA drivers. For all other drivers (e.g. USB or
PCIe based network adapters) it does not use label.
