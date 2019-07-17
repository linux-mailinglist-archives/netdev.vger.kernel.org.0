Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CACD36BC59
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 14:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbfGQM3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 08:29:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54074 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfGQM3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 08:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dnreV3P2dVdrxgr+lCMeP1cAFAnB0dAy0w+uem8JYDU=; b=mEsAsv+YDb9f0HtbIJiGoY7jRU
        m+q5Y0u5NuuG5cL6Dhahlc6p2tHSzGbK0CKcu/0rGencpAjY9q+1Wpgkp0ie1XAzXd1v+XDwb1815
        gT3toJoLJTWEnISGiGT7ABOeUubQ01Ob61xm2rWnRzNZxdOHmz/32WRbkF2Y3DHHvw6Bnx2nrsvWq
        v5sjy5NJXtpIkRVGwbXwZRwhBLqIiioekRo7k+QEZrXBVdHZWT7aIWH/wPPcBM7KfTawpZmZhCy0f
        DfLEcrnvLO3JKw+Nxd3O9cqJUcbj6PBYEKU+/Ra+xGOkwCA80zqY2S8MF2yByjQpScZC6fF7IKHYS
        6WF9iXkg==;
Received: from [191.33.154.161] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hnj2n-0006fg-0M; Wed, 17 Jul 2019 12:28:27 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hnj2k-00052j-4x; Wed, 17 Jul 2019 09:28:22 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Peter Rosin <peda@axentia.se>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Guenter Roeck <groeck@chromium.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Sebastian Reichel <sre@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v4 13/15] docs: ABI: testing: make the files compatible with ReST output
Date:   Wed, 17 Jul 2019 09:28:17 -0300
Message-Id: <88d15fa38167e3f2e73e65e1c1a1f39bca0267b4.1563365880.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1563365880.git.mchehab+samsung@kernel.org>
References: <cover.1563365880.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some files over there won't parse well by Sphinx.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 .../ABI/testing/configfs-spear-pcie-gadget    |  36 +--
 Documentation/ABI/testing/configfs-usb-gadget |  77 +++---
 .../ABI/testing/configfs-usb-gadget-hid       |  10 +-
 .../ABI/testing/configfs-usb-gadget-rndis     |  16 +-
 .../ABI/testing/configfs-usb-gadget-uac1      |  18 +-
 .../ABI/testing/configfs-usb-gadget-uvc       | 220 +++++++++-------
 Documentation/ABI/testing/debugfs-ec          |  11 +-
 Documentation/ABI/testing/debugfs-pktcdvd     |  11 +-
 Documentation/ABI/testing/dev-kmsg            |  27 +-
 Documentation/ABI/testing/evm                 |  17 +-
 Documentation/ABI/testing/ima_policy          | 128 +++++-----
 Documentation/ABI/testing/procfs-diskstats    |  40 +--
 Documentation/ABI/testing/sysfs-block         |  26 +-
 Documentation/ABI/testing/sysfs-block-device  |   2 +
 Documentation/ABI/testing/sysfs-bus-acpi      |  18 +-
 .../sysfs-bus-event_source-devices-format     |   3 +-
 .../ABI/testing/sysfs-bus-i2c-devices-pca954x |  27 +-
 Documentation/ABI/testing/sysfs-bus-iio       |  11 +
 .../sysfs-bus-iio-adc-envelope-detector       |   5 +-
 .../ABI/testing/sysfs-bus-iio-cros-ec         |   2 +-
 .../ABI/testing/sysfs-bus-iio-dfsdm-adc-stm32 |  10 +-
 .../ABI/testing/sysfs-bus-iio-lptimer-stm32   |  29 ++-
 .../sysfs-bus-iio-magnetometer-hmc5843        |  19 +-
 .../sysfs-bus-iio-temperature-max31856        |  19 +-
 .../ABI/testing/sysfs-bus-iio-timer-stm32     | 114 +++++----
 .../testing/sysfs-bus-intel_th-devices-msc    |   4 +
 Documentation/ABI/testing/sysfs-bus-nfit      |   2 +-
 .../testing/sysfs-bus-pci-devices-aer_stats   | 119 +++++----
 Documentation/ABI/testing/sysfs-bus-rapidio   |  23 +-
 .../ABI/testing/sysfs-bus-thunderbolt         |  40 +--
 Documentation/ABI/testing/sysfs-bus-usb       |  30 ++-
 .../testing/sysfs-bus-usb-devices-usbsevseg   |   7 +-
 Documentation/ABI/testing/sysfs-bus-vfio-mdev |  10 +-
 Documentation/ABI/testing/sysfs-class-cxl     |  15 +-
 Documentation/ABI/testing/sysfs-class-led     |   2 +-
 Documentation/ABI/testing/sysfs-class-mic.txt |  52 ++--
 Documentation/ABI/testing/sysfs-class-ocxl    |   3 +
 Documentation/ABI/testing/sysfs-class-power   |  73 +++++-
 .../ABI/testing/sysfs-class-power-twl4030     |  33 +--
 Documentation/ABI/testing/sysfs-class-rc      |  30 ++-
 .../ABI/testing/sysfs-class-scsi_host         |   7 +-
 Documentation/ABI/testing/sysfs-class-typec   |  12 +-
 .../testing/sysfs-devices-platform-ACPI-TAD   |   4 +
 .../ABI/testing/sysfs-devices-platform-docg3  |  10 +-
 .../sysfs-devices-platform-sh_mobile_lcdc_fb  |   8 +-
 .../ABI/testing/sysfs-devices-system-cpu      |  99 +++++---
 .../ABI/testing/sysfs-devices-system-ibm-rtl  |   6 +-
 .../testing/sysfs-driver-bd9571mwv-regulator  |   4 +
 Documentation/ABI/testing/sysfs-driver-genwqe |  11 +-
 .../testing/sysfs-driver-hid-logitech-lg4ff   |  18 +-
 .../ABI/testing/sysfs-driver-hid-wiimote      |  11 +-
 .../ABI/testing/sysfs-driver-samsung-laptop   |  13 +-
 .../ABI/testing/sysfs-driver-toshiba_acpi     |  26 ++
 .../ABI/testing/sysfs-driver-toshiba_haps     |   2 +
 Documentation/ABI/testing/sysfs-driver-wacom  |   4 +-
 Documentation/ABI/testing/sysfs-firmware-acpi | 237 +++++++++---------
 .../ABI/testing/sysfs-firmware-dmi-entries    |  50 ++--
 Documentation/ABI/testing/sysfs-firmware-gsmi |   2 +-
 .../ABI/testing/sysfs-firmware-memmap         |  16 +-
 Documentation/ABI/testing/sysfs-fs-ext4       |   4 +-
 .../ABI/testing/sysfs-hypervisor-xen          |  13 +-
 .../ABI/testing/sysfs-kernel-boot_params      |  23 +-
 .../ABI/testing/sysfs-kernel-mm-hugepages     |  12 +-
 .../ABI/testing/sysfs-platform-asus-laptop    |  21 +-
 .../ABI/testing/sysfs-platform-asus-wmi       |   1 +
 Documentation/ABI/testing/sysfs-platform-at91 |  10 +-
 .../ABI/testing/sysfs-platform-eeepc-laptop   |  14 +-
 .../ABI/testing/sysfs-platform-ideapad-laptop |   9 +-
 .../sysfs-platform-intel-wmi-thunderbolt      |   1 +
 .../ABI/testing/sysfs-platform-sst-atom       |  13 +-
 .../ABI/testing/sysfs-platform-usbip-vudc     |  11 +-
 Documentation/ABI/testing/sysfs-ptp           |   2 +-
 Documentation/ABI/testing/sysfs-uevent        |  10 +-
 Documentation/admin-guide/abi-testing.rst     |   1 +
 74 files changed, 1227 insertions(+), 797 deletions(-)

diff --git a/Documentation/ABI/testing/configfs-spear-pcie-gadget b/Documentation/ABI/testing/configfs-spear-pcie-gadget
index 840c324ef34d..cf877bd341df 100644
--- a/Documentation/ABI/testing/configfs-spear-pcie-gadget
+++ b/Documentation/ABI/testing/configfs-spear-pcie-gadget
@@ -10,22 +10,24 @@ Description:
 	This interfaces can be used to show spear's PCIe device capability.
 
 	Nodes are only visible when configfs is mounted. To mount configfs
-	in /config directory use:
-	# mount -t configfs none /config/
+	in /config directory use::
 
-	For nth PCIe Device Controller
-	/config/pcie-gadget.n/
-		link ... used to enable ltssm and read its status.
-		int_type ...used to configure and read type of supported
-			interrupt
-		no_of_msi ... used to configure number of MSI vector needed and
+	  # mount -t configfs none /config/
+
+	For nth PCIe Device Controller /config/pcie-gadget.n/:
+
+	=============== ======================================================
+	link		used to enable ltssm and read its status.
+	int_type	used to configure and read type of supported interrupt
+	no_of_msi	used to configure number of MSI vector needed and
 			to read no of MSI granted.
-		inta ... write 1 to assert INTA and 0 to de-assert.
-		send_msi ... write MSI vector to be sent.
-		vendor_id ... used to write and read vendor id (hex)
-		device_id ... used to write and read device id (hex)
-		bar0_size ... used to write and read bar0_size
-		bar0_address ... used to write and read bar0 mapped area in hex.
-		bar0_rw_offset ... used to write and read offset of bar0 where
-			bar0_data will be written or read.
-		bar0_data ... used to write and read data at bar0_rw_offset.
+	inta		write 1 to assert INTA and 0 to de-assert.
+	send_msi	write MSI vector to be sent.
+	vendor_id	used to write and read vendor id (hex)
+	device_id	used to write and read device id (hex)
+	bar0_size	used to write and read bar0_size
+	bar0_address	used to write and read bar0 mapped area in hex.
+	bar0_rw_offset	used to write and read offset of bar0 where bar0_data
+			will be written or read.
+	bar0_data	used to write and read data at bar0_rw_offset.
+	=============== ======================================================
diff --git a/Documentation/ABI/testing/configfs-usb-gadget b/Documentation/ABI/testing/configfs-usb-gadget
index 95a36589a66b..03d5442a14f9 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget
+++ b/Documentation/ABI/testing/configfs-usb-gadget
@@ -12,18 +12,20 @@ Description:
 
 		The attributes of a gadget:
 
-		UDC		- bind a gadget to UDC/unbind a gadget;
-				write UDC's name found in /sys/class/udc/*
-				to bind a gadget, empty string "" to unbind.
+		================  ============================================
+		UDC		  bind a gadget to UDC/unbind a gadget;
+				  write UDC's name found in /sys/class/udc/*
+				  to bind a gadget, empty string "" to unbind.
 
-		bDeviceClass	- USB device class code
-		bDeviceSubClass	- USB device subclass code
-		bDeviceProtocol	- USB device protocol code
-		bMaxPacketSize0	- maximum endpoint 0 packet size
-		bcdDevice	- bcd device release number
-		bcdUSB		- bcd USB specification version number
-		idProduct	- product ID
-		idVendor	- vendor ID
+		bDeviceClass	  USB device class code
+		bDeviceSubClass	  USB device subclass code
+		bDeviceProtocol	  USB device protocol code
+		bMaxPacketSize0	  maximum endpoint 0 packet size
+		bcdDevice	  bcd device release number
+		bcdUSB		  bcd USB specification version number
+		idProduct	  product ID
+		idVendor	  vendor ID
+		================  ============================================
 
 What:		/config/usb-gadget/gadget/configs
 Date:		Jun 2013
@@ -37,8 +39,10 @@ KernelVersion:	3.11
 Description:
 		The attributes of a configuration:
 
-		bmAttributes	- configuration characteristics
-		MaxPower	- maximum power consumption from the bus
+		================  ======================================
+		bmAttributes	  configuration characteristics
+		MaxPower	  maximum power consumption from the bus
+		================  ======================================
 
 What:		/config/usb-gadget/gadget/configs/config/strings
 Date:		Jun 2013
@@ -53,7 +57,9 @@ KernelVersion:	3.11
 Description:
 		The attributes:
 
-		configuration	- configuration description
+		================  =========================
+		configuration	  configuration description
+		================  =========================
 
 
 What:		/config/usb-gadget/gadget/functions
@@ -72,8 +78,10 @@ Description:
 
 		The attributes:
 
-		compatible_id		- 8-byte string for "Compatible ID"
-		sub_compatible_id	- 8-byte string for "Sub Compatible ID"
+		=================	=====================================
+		compatible_id		8-byte string for "Compatible ID"
+		sub_compatible_id	8-byte string for "Sub Compatible ID"
+		=================	=====================================
 
 What:		/config/usb-gadget/gadget/functions/<func>.<inst>/interface.<n>/<property>
 Date:		May 2014
@@ -85,16 +93,19 @@ Description:
 
 		The attributes:
 
-		type		- value 1..7 for interpreting the data
-				1: unicode string
-				2: unicode string with environment variable
-				3: binary
-				4: little-endian 32-bit
-				5: big-endian 32-bit
-				6: unicode string with a symbolic link
-				7: multiple unicode strings
-		data		- blob of data to be interpreted depending on
+		=====		===============================================
+		type		value 1..7 for interpreting the data
+
+				- 1: unicode string
+				- 2: unicode string with environment variable
+				- 3: binary
+				- 4: little-endian 32-bit
+				- 5: big-endian 32-bit
+				- 6: unicode string with a symbolic link
+				- 7: multiple unicode strings
+		data		blob of data to be interpreted depending on
 				type
+		=====		===============================================
 
 What:		/config/usb-gadget/gadget/strings
 Date:		Jun 2013
@@ -109,9 +120,11 @@ KernelVersion:	3.11
 Description:
 		The attributes:
 
-		serialnumber	- gadget's serial number (string)
-		product		- gadget's product description
-		manufacturer	- gadget's manufacturer description
+		============	=================================
+		serialnumber	gadget's serial number (string)
+		product		gadget's product description
+		manufacturer	gadget's manufacturer description
+		============	=================================
 
 What:		/config/usb-gadget/gadget/os_desc
 Date:		May 2014
@@ -119,8 +132,10 @@ KernelVersion:	3.16
 Description:
 		This group contains "OS String" extension handling attributes.
 
-		use		- flag turning "OS Desctiptors" support on/off
-		b_vendor_code	- one-byte value used for custom per-device and
+		=============	===============================================
+		use		flag turning "OS Desctiptors" support on/off
+		b_vendor_code	one-byte value used for custom per-device and
 				per-interface requests
-		qw_sign		- an identifier to be reported as "OS String"
+		qw_sign		an identifier to be reported as "OS String"
 				proper
+		=============	===============================================
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-hid b/Documentation/ABI/testing/configfs-usb-gadget-hid
index f12e00e6baa3..748705c4cb58 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-hid
+++ b/Documentation/ABI/testing/configfs-usb-gadget-hid
@@ -4,8 +4,10 @@ KernelVersion:	3.19
 Description:
 		The attributes:
 
-		protocol	- HID protocol to use
-		report_desc	- blob corresponding to HID report descriptors
+		=============	============================================
+		protocol	HID protocol to use
+		report_desc	blob corresponding to HID report descriptors
 				except the data passed through /dev/hidg<N>
-		report_length	- HID report length
-		subclass	- HID device subclass to use
+		report_length	HID report length
+		subclass	HID device subclass to use
+		=============	============================================
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-rndis b/Documentation/ABI/testing/configfs-usb-gadget-rndis
index 137399095d74..9416eda7fe93 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-rndis
+++ b/Documentation/ABI/testing/configfs-usb-gadget-rndis
@@ -4,14 +4,16 @@ KernelVersion:	3.11
 Description:
 		The attributes:
 
-		ifname		- network device interface name associated with
+		=========	=============================================
+		ifname		network device interface name associated with
 				this function instance
-		qmult		- queue length multiplier for high and
+		qmult		queue length multiplier for high and
 				super speed
-		host_addr	- MAC address of host's end of this
+		host_addr	MAC address of host's end of this
 				Ethernet over USB link
-		dev_addr	- MAC address of device's end of this
+		dev_addr	MAC address of device's end of this
 				Ethernet over USB link
-		class		- USB interface class, default is 02 (hex)
-		subclass	- USB interface subclass, default is 06 (hex)
-		protocol	- USB interface protocol, default is 00 (hex)
+		class		USB interface class, default is 02 (hex)
+		subclass	USB interface subclass, default is 06 (hex)
+		protocol	USB interface protocol, default is 00 (hex)
+		=========	=============================================
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uac1 b/Documentation/ABI/testing/configfs-usb-gadget-uac1
index abfe447c848f..dc23fd776943 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-uac1
+++ b/Documentation/ABI/testing/configfs-usb-gadget-uac1
@@ -4,11 +4,13 @@ KernelVersion:	4.14
 Description:
 		The attributes:
 
-		c_chmask - capture channel mask
-		c_srate - capture sampling rate
-		c_ssize - capture sample size (bytes)
-		p_chmask - playback channel mask
-		p_srate - playback sampling rate
-		p_ssize - playback sample size (bytes)
-		req_number - the number of pre-allocated request
-			for both capture and playback
+		==========	===================================
+		c_chmask	capture channel mask
+		c_srate		capture sampling rate
+		c_ssize		capture sample size (bytes)
+		p_chmask	playback channel mask
+		p_srate		playback sampling rate
+		p_ssize		playback sample size (bytes)
+		req_number	the number of pre-allocated request
+				for both capture and playback
+		==========	===================================
diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uvc b/Documentation/ABI/testing/configfs-usb-gadget-uvc
index 809765bd9573..cee81b0347bb 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-uvc
+++ b/Documentation/ABI/testing/configfs-usb-gadget-uvc
@@ -3,9 +3,11 @@ Date:		Dec 2014
 KernelVersion:	4.0
 Description:	UVC function directory
 
-		streaming_maxburst	- 0..15 (ss only)
-		streaming_maxpacket	- 1..1023 (fs), 1..3072 (hs/ss)
-		streaming_interval	- 1..16
+		===================	=============================
+		streaming_maxburst	0..15 (ss only)
+		streaming_maxpacket	1..1023 (fs), 1..3072 (hs/ss)
+		streaming_interval	1..16
+		===================	=============================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/control
 Date:		Dec 2014
@@ -13,8 +15,11 @@ KernelVersion:	4.0
 Description:	Control descriptors
 
 		All attributes read only:
-		bInterfaceNumber	- USB interface number for this
-					  streaming interface
+
+		================	=============================
+		bInterfaceNumber	USB interface number for this
+					streaming interface
+		================	=============================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/control/class
 Date:		Dec 2014
@@ -47,13 +52,16 @@ KernelVersion:	4.0
 Description:	Default output terminal descriptors
 
 		All attributes read only:
-		iTerminal	- index of string descriptor
-		bSourceID 	- id of the terminal to which this terminal
+
+		==============	=============================================
+		iTerminal	index of string descriptor
+		bSourceID 	id of the terminal to which this terminal
 				is connected
-		bAssocTerminal	- id of the input terminal to which this output
+		bAssocTerminal	id of the input terminal to which this output
 				terminal is associated
-		wTerminalType	- terminal type
-		bTerminalID	- a non-zero id of this terminal
+		wTerminalType	terminal type
+		bTerminalID	a non-zero id of this terminal
+		==============	=============================================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/control/terminal/camera
 Date:		Dec 2014
@@ -66,16 +74,19 @@ KernelVersion:	4.0
 Description:	Default camera terminal descriptors
 
 		All attributes read only:
-		bmControls		- bitmap specifying which controls are
-					supported for the video stream
-		wOcularFocalLength	- the value of Locular
-		wObjectiveFocalLengthMax- the value of Lmin
-		wObjectiveFocalLengthMin- the value of Lmax
-		iTerminal		- index of string descriptor
-		bAssocTerminal		- id of the output terminal to which
-					this terminal is connected
-		wTerminalType		- terminal type
-		bTerminalID		- a non-zero id of this terminal
+
+		========================  ====================================
+		bmControls		  bitmap specifying which controls are
+					  supported for the video stream
+		wOcularFocalLength	  the value of Locular
+		wObjectiveFocalLengthMax  the value of Lmin
+		wObjectiveFocalLengthMin  the value of Lmax
+		iTerminal		  index of string descriptor
+		bAssocTerminal		  id of the output terminal to which
+					  this terminal is connected
+		wTerminalType		  terminal type
+		bTerminalID		  a non-zero id of this terminal
+		========================  ====================================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/control/processing
 Date:		Dec 2014
@@ -88,13 +99,16 @@ KernelVersion:	4.0
 Description:	Default processing unit descriptors
 
 		All attributes read only:
-		iProcessing	- index of string descriptor
-		bmControls	- bitmap specifying which controls are
+
+		===============	========================================
+		iProcessing	index of string descriptor
+		bmControls	bitmap specifying which controls are
 				supported for the video stream
-		wMaxMultiplier	- maximum digital magnification x100
-		bSourceID	- id of the terminal to which this unit is
+		wMaxMultiplier	maximum digital magnification x100
+		bSourceID	id of the terminal to which this unit is
 				connected
-		bUnitID		- a non-zero id of this unit
+		bUnitID		a non-zero id of this unit
+		===============	========================================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/control/header
 Date:		Dec 2014
@@ -114,8 +128,11 @@ KernelVersion:	4.0
 Description:	Streaming descriptors
 
 		All attributes read only:
-		bInterfaceNumber	- USB interface number for this
-					  streaming interface
+
+		================	=============================
+		bInterfaceNumber	USB interface number for this
+					streaming interface
+		================	=============================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/streaming/class
 Date:		Dec 2014
@@ -148,13 +165,16 @@ KernelVersion:	4.0
 Description:	Default color matching descriptors
 
 		All attributes read only:
-		bMatrixCoefficients	- matrix used to compute luma and
-					chroma values from the color primaries
-		bTransferCharacteristics- optoelectronic transfer
-					characteristic of the source picutre,
-					also called the gamma function
-		bColorPrimaries		- color primaries and the reference
-					white
+
+		========================  ======================================
+		bMatrixCoefficients	  matrix used to compute luma and
+					  chroma values from the color primaries
+		bTransferCharacteristics  optoelectronic transfer
+					  characteristic of the source picutre,
+					  also called the gamma function
+		bColorPrimaries		  color primaries and the reference
+					  white
+		========================  ======================================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/streaming/mjpeg
 Date:		Dec 2014
@@ -168,47 +188,52 @@ Description:	Specific MJPEG format descriptors
 
 		All attributes read only,
 		except bmaControls and bDefaultFrameIndex:
-		bFormatIndex		- unique id for this format descriptor;
+
+		===================	=====================================
+		bFormatIndex		unique id for this format descriptor;
 					only defined after parent header is
 					linked into the streaming class;
 					read-only
-		bmaControls		- this format's data for bmaControls in
+		bmaControls		this format's data for bmaControls in
 					the streaming header
-		bmInterfaceFlags	- specifies interlace information,
+		bmInterfaceFlags	specifies interlace information,
 					read-only
-		bAspectRatioY		- the X dimension of the picture aspect
+		bAspectRatioY		the X dimension of the picture aspect
 					ratio, read-only
-		bAspectRatioX		- the Y dimension of the picture aspect
+		bAspectRatioX		the Y dimension of the picture aspect
 					ratio, read-only
-		bmFlags			- characteristics of this format,
+		bmFlags			characteristics of this format,
 					read-only
-		bDefaultFrameIndex	- optimum frame index for this stream
+		bDefaultFrameIndex	optimum frame index for this stream
+		===================	=====================================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/streaming/mjpeg/name/name
 Date:		Dec 2014
 KernelVersion:	4.0
 Description:	Specific MJPEG frame descriptors
 
-		bFrameIndex		- unique id for this framedescriptor;
-					only defined after parent format is
-					linked into the streaming header;
-					read-only
-		dwFrameInterval		- indicates how frame interval can be
-					programmed; a number of values
-					separated by newline can be specified
-		dwDefaultFrameInterval	- the frame interval the device would
-					like to use as default
-		dwMaxVideoFrameBufferSize- the maximum number of bytes the
-					compressor will produce for a video
-					frame or still image
-		dwMaxBitRate		- the maximum bit rate at the shortest
-					frame interval in bps
-		dwMinBitRate		- the minimum bit rate at the longest
-					frame interval in bps
-		wHeight			- height of decoded bitmap frame in px
-		wWidth			- width of decoded bitmam frame in px
-		bmCapabilities		- still image support, fixed frame-rate
-					support
+		=========================  =====================================
+		bFrameIndex		   unique id for this framedescriptor;
+					   only defined after parent format is
+					   linked into the streaming header;
+					   read-only
+		dwFrameInterval		   indicates how frame interval can be
+					   programmed; a number of values
+					   separated by newline can be specified
+		dwDefaultFrameInterval	   the frame interval the device would
+					   like to use as default
+		dwMaxVideoFrameBufferSize  the maximum number of bytes the
+					   compressor will produce for a video
+					   frame or still image
+		dwMaxBitRate		   the maximum bit rate at the shortest
+					   frame interval in bps
+		dwMinBitRate		   the minimum bit rate at the longest
+					   frame interval in bps
+		wHeight			   height of decoded bitmap frame in px
+		wWidth			   width of decoded bitmam frame in px
+		bmCapabilities		   still image support, fixed frame-rate
+					   support
+		=========================  =====================================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/streaming/uncompressed
 Date:		Dec 2014
@@ -220,50 +245,54 @@ Date:		Dec 2014
 KernelVersion:	4.0
 Description:	Specific uncompressed format descriptors
 
-		bFormatIndex		- unique id for this format descriptor;
+		==================	=======================================
+		bFormatIndex		unique id for this format descriptor;
 					only defined after parent header is
 					linked into the streaming class;
 					read-only
-		bmaControls		- this format's data for bmaControls in
+		bmaControls		this format's data for bmaControls in
 					the streaming header
-		bmInterfaceFlags	- specifies interlace information,
+		bmInterfaceFlags	specifies interlace information,
 					read-only
-		bAspectRatioY		- the X dimension of the picture aspect
+		bAspectRatioY		the X dimension of the picture aspect
 					ratio, read-only
-		bAspectRatioX		- the Y dimension of the picture aspect
+		bAspectRatioX		the Y dimension of the picture aspect
 					ratio, read-only
-		bDefaultFrameIndex	- optimum frame index for this stream
-		bBitsPerPixel		- number of bits per pixel used to
+		bDefaultFrameIndex	optimum frame index for this stream
+		bBitsPerPixel		number of bits per pixel used to
 					specify color in the decoded video
 					frame
-		guidFormat		- globally unique id used to identify
+		guidFormat		globally unique id used to identify
 					stream-encoding format
+		==================	=======================================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/streaming/uncompressed/name/name
 Date:		Dec 2014
 KernelVersion:	4.0
 Description:	Specific uncompressed frame descriptors
 
-		bFrameIndex		- unique id for this framedescriptor;
-					only defined after parent format is
-					linked into the streaming header;
-					read-only
-		dwFrameInterval		- indicates how frame interval can be
-					programmed; a number of values
-					separated by newline can be specified
-		dwDefaultFrameInterval	- the frame interval the device would
-					like to use as default
-		dwMaxVideoFrameBufferSize- the maximum number of bytes the
-					compressor will produce for a video
-					frame or still image
-		dwMaxBitRate		- the maximum bit rate at the shortest
-					frame interval in bps
-		dwMinBitRate		- the minimum bit rate at the longest
-					frame interval in bps
-		wHeight			- height of decoded bitmap frame in px
-		wWidth			- width of decoded bitmam frame in px
-		bmCapabilities		- still image support, fixed frame-rate
-					support
+		=========================  =====================================
+		bFrameIndex		   unique id for this framedescriptor;
+					   only defined after parent format is
+					   linked into the streaming header;
+					   read-only
+		dwFrameInterval		   indicates how frame interval can be
+					   programmed; a number of values
+					   separated by newline can be specified
+		dwDefaultFrameInterval	   the frame interval the device would
+					   like to use as default
+		dwMaxVideoFrameBufferSize  the maximum number of bytes the
+					   compressor will produce for a video
+					   frame or still image
+		dwMaxBitRate		   the maximum bit rate at the shortest
+					   frame interval in bps
+		dwMinBitRate		   the minimum bit rate at the longest
+					   frame interval in bps
+		wHeight			   height of decoded bitmap frame in px
+		wWidth			   width of decoded bitmam frame in px
+		bmCapabilities		   still image support, fixed frame-rate
+					   support
+		=========================  =====================================
 
 What:		/config/usb-gadget/gadget/functions/uvc.name/streaming/header
 Date:		Dec 2014
@@ -276,17 +305,20 @@ KernelVersion:	4.0
 Description:	Specific streaming header descriptors
 
 		All attributes read only:
-		bTriggerUsage		- how the host software will respond to
+
+		====================	=====================================
+		bTriggerUsage		how the host software will respond to
 					a hardware trigger interrupt event
-		bTriggerSupport		- flag specifying if hardware
+		bTriggerSupport		flag specifying if hardware
 					triggering is supported
-		bStillCaptureMethod	- method of still image caputre
+		bStillCaptureMethod	method of still image caputre
 					supported
-		bTerminalLink		- id of the output terminal to which
+		bTerminalLink		id of the output terminal to which
 					the video endpoint of this interface
 					is connected
-		bmInfo			- capabilities of this video streaming
+		bmInfo			capabilities of this video streaming
 					interface
+		====================	=====================================
 
 What:		/sys/class/udc/udc.name/device/gadget/video4linux/video.name/function_name
 Date:		May 2018
diff --git a/Documentation/ABI/testing/debugfs-ec b/Documentation/ABI/testing/debugfs-ec
index 6546115a94da..ab6099daa8f5 100644
--- a/Documentation/ABI/testing/debugfs-ec
+++ b/Documentation/ABI/testing/debugfs-ec
@@ -6,7 +6,7 @@ Description:
 General information like which GPE is assigned to the EC and whether
 the global lock should get used.
 Knowing the EC GPE one can watch the amount of HW events related to
-the EC here (XY -> GPE number from /sys/kernel/debug/ec/*/gpe):
+the EC here (XY -> GPE number from `/sys/kernel/debug/ec/*/gpe`):
 /sys/firmware/acpi/interrupts/gpeXY
 
 The io file is binary and a userspace tool located here:
@@ -14,7 +14,8 @@ ftp://ftp.suse.com/pub/people/trenn/sources/ec/
 should get used to read out the 256 Embedded Controller registers
 or writing to them.
 
-CAUTION: Do not write to the Embedded Controller if you don't know
-what you are doing! Rebooting afterwards also is a good idea.
-This can influence the way your machine is cooled and fans may
-not get switched on again after you did a wrong write.
+CAUTION:
+  Do not write to the Embedded Controller if you don't know
+  what you are doing! Rebooting afterwards also is a good idea.
+  This can influence the way your machine is cooled and fans may
+  not get switched on again after you did a wrong write.
diff --git a/Documentation/ABI/testing/debugfs-pktcdvd b/Documentation/ABI/testing/debugfs-pktcdvd
index cf11736acb76..787907d70462 100644
--- a/Documentation/ABI/testing/debugfs-pktcdvd
+++ b/Documentation/ABI/testing/debugfs-pktcdvd
@@ -4,16 +4,15 @@ KernelVersion:  2.6.20
 Contact:        Thomas Maier <balagi@justmail.de>
 Description:
 
-debugfs interface
------------------
-
 The pktcdvd module (packet writing driver) creates
 these files in debugfs:
 
 /sys/kernel/debug/pktcdvd/pktcdvd[0-7]/
+
+    ====            ====== ====================================
     info            (0444) Lots of driver statistics and infos.
+    ====            ====== ====================================
 
-Example:
--------
+Example::
 
-cat /sys/kernel/debug/pktcdvd/pktcdvd0/info
+    cat /sys/kernel/debug/pktcdvd/pktcdvd0/info
diff --git a/Documentation/ABI/testing/dev-kmsg b/Documentation/ABI/testing/dev-kmsg
index fff817efa508..69827ec89e09 100644
--- a/Documentation/ABI/testing/dev-kmsg
+++ b/Documentation/ABI/testing/dev-kmsg
@@ -6,6 +6,7 @@ Description:	The /dev/kmsg character device node provides userspace access
 		to the kernel's printk buffer.
 
 		Injecting messages:
+
 		Every write() to the opened device node places a log entry in
 		the kernel's printk buffer.
 
@@ -21,6 +22,7 @@ Description:	The /dev/kmsg character device node provides userspace access
 		the messages can always be reliably determined.
 
 		Accessing the buffer:
+
 		Every read() from the opened device node receives one record
 		of the kernel's printk buffer.
 
@@ -48,6 +50,7 @@ Description:	The /dev/kmsg character device node provides userspace access
 		if needed, without limiting the interface to a single reader.
 
 		The device supports seek with the following parameters:
+
 		SEEK_SET, 0
 		  seek to the first entry in the buffer
 		SEEK_END, 0
@@ -76,18 +79,22 @@ Description:	The /dev/kmsg character device node provides userspace access
 		readable context of the message, for reliable processing in
 		userspace.
 
-		Example:
-		7,160,424069,-;pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
-		 SUBSYSTEM=acpi
-		 DEVICE=+acpi:PNP0A03:00
-		6,339,5140900,-;NET: Registered protocol family 10
-		30,340,5690716,-;udevd[80]: starting version 181
+		Example::
+
+		  7,160,424069,-;pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
+		   SUBSYSTEM=acpi
+		   DEVICE=+acpi:PNP0A03:00
+		  6,339,5140900,-;NET: Registered protocol family 10
+		  30,340,5690716,-;udevd[80]: starting version 181
 
 		The DEVICE= key uniquely identifies devices the following way:
-		  b12:8        - block dev_t
-		  c127:3       - char dev_t
-		  n8           - netdev ifindex
-		  +sound:card0 - subsystem:devname
+
+		  ============  =================
+		  b12:8         block dev_t
+		  c127:3        char dev_t
+		  n8            netdev ifindex
+		  +sound:card0  subsystem:devname
+		  ============  =================
 
 		The flags field carries '-' by default. A 'c' indicates a
 		fragment of a line. All following fragments are flagged with
diff --git a/Documentation/ABI/testing/evm b/Documentation/ABI/testing/evm
index 201d10319fa1..3c477ba48a31 100644
--- a/Documentation/ABI/testing/evm
+++ b/Documentation/ABI/testing/evm
@@ -17,26 +17,33 @@ Description:
 		echoing a value to <securityfs>/evm made up of the
 		following bits:
 
+		===	  ==================================================
 		Bit	  Effect
+		===	  ==================================================
 		0	  Enable HMAC validation and creation
 		1	  Enable digital signature validation
 		2	  Permit modification of EVM-protected metadata at
 			  runtime. Not supported if HMAC validation and
 			  creation is enabled.
 		31	  Disable further runtime modification of EVM policy
+		===	  ==================================================
 
-		For example:
+		For example::
 
-		echo 1 ><securityfs>/evm
+		  echo 1 ><securityfs>/evm
 
 		will enable HMAC validation and creation
 
-		echo 0x80000003 ><securityfs>/evm
+		::
+
+		  echo 0x80000003 ><securityfs>/evm
 
 		will enable HMAC and digital signature validation and
 		HMAC creation and disable all further modification of policy.
 
-		echo 0x80000006 ><securityfs>/evm
+		::
+
+		  echo 0x80000006 ><securityfs>/evm
 
 		will enable digital signature validation, permit
 		modification of EVM-protected metadata and
@@ -65,7 +72,7 @@ Description:
 		Shows the set of extended attributes used to calculate or
 		validate the EVM signature, and allows additional attributes
 		to be added at runtime. Any signatures generated after
-		additional attributes are added (and on files posessing those
+		additional attributes are added (and on files possessing those
 		additional attributes) will only be valid if the same
 		additional attributes are configured on system boot. Writing
 		a single period (.) will lock the xattr list from any further
diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index fc376a323908..f9a6abc8f583 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -15,73 +15,75 @@ Description:
 		IMA appraisal, if configured, uses these file measurements
 		for local measurement appraisal.
 
-		rule format: action [condition ...]
+		::
 
-		action: measure | dont_measure | appraise | dont_appraise |
-			audit | hash | dont_hash
-		condition:= base | lsm  [option]
+		  rule format: action [condition ...]
+
+		  action: measure | dont_measure | appraise | dont_appraise |
+			  audit | hash | dont_hash
+		  condition:= base | lsm  [option]
 			base:	[[func=] [mask=] [fsmagic=] [fsuuid=] [uid=]
 				[euid=] [fowner=] [fsname=]]
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
 				 [obj_user=] [obj_role=] [obj_type=]]
 			option:	[[appraise_type=]] [template=] [permit_directio]
-		base: 	func:= [BPRM_CHECK][MMAP_CHECK][CREDS_CHECK][FILE_CHECK][MODULE_CHECK]
-				[FIRMWARE_CHECK]
-				[KEXEC_KERNEL_CHECK] [KEXEC_INITRAMFS_CHECK]
-				[KEXEC_CMDLINE]
-			mask:= [[^]MAY_READ] [[^]MAY_WRITE] [[^]MAY_APPEND]
-			       [[^]MAY_EXEC]
-			fsmagic:= hex value
-			fsuuid:= file system UUID (e.g 8bcbe394-4f13-4144-be8e-5aa9ea2ce2f6)
-			uid:= decimal value
-			euid:= decimal value
-			fowner:= decimal value
-		lsm:  	are LSM specific
-		option:	appraise_type:= [imasig]
-			template:= name of a defined IMA template type
-			(eg, ima-ng). Only valid when action is "measure".
-			pcr:= decimal value
+		  base: 	func:= [BPRM_CHECK][MMAP_CHECK][CREDS_CHECK][FILE_CHECK][MODULE_CHECK]
+				  [FIRMWARE_CHECK]
+				  [KEXEC_KERNEL_CHECK] [KEXEC_INITRAMFS_CHECK]
+				  [KEXEC_CMDLINE]
+			  mask:= [[^]MAY_READ] [[^]MAY_WRITE] [[^]MAY_APPEND]
+			         [[^]MAY_EXEC]
+			  fsmagic:= hex value
+			  fsuuid:= file system UUID (e.g 8bcbe394-4f13-4144-be8e-5aa9ea2ce2f6)
+			  uid:= decimal value
+			  euid:= decimal value
+			  fowner:= decimal value
+		  lsm:  	are LSM specific
+		  option:	appraise_type:= [imasig]
+				template:= name of a defined IMA template type
+				(eg, ima-ng). Only valid when action is "measure".
+				pcr:= decimal value
 
-		default policy:
-			# PROC_SUPER_MAGIC
-			dont_measure fsmagic=0x9fa0
-			dont_appraise fsmagic=0x9fa0
-			# SYSFS_MAGIC
-			dont_measure fsmagic=0x62656572
-			dont_appraise fsmagic=0x62656572
-			# DEBUGFS_MAGIC
-			dont_measure fsmagic=0x64626720
-			dont_appraise fsmagic=0x64626720
-			# TMPFS_MAGIC
-			dont_measure fsmagic=0x01021994
-			dont_appraise fsmagic=0x01021994
-			# RAMFS_MAGIC
-			dont_appraise fsmagic=0x858458f6
-			# DEVPTS_SUPER_MAGIC
-			dont_measure fsmagic=0x1cd1
-			dont_appraise fsmagic=0x1cd1
-			# BINFMTFS_MAGIC
-			dont_measure fsmagic=0x42494e4d
-			dont_appraise fsmagic=0x42494e4d
-			# SECURITYFS_MAGIC
-			dont_measure fsmagic=0x73636673
-			dont_appraise fsmagic=0x73636673
-			# SELINUX_MAGIC
-			dont_measure fsmagic=0xf97cff8c
-			dont_appraise fsmagic=0xf97cff8c
-			# CGROUP_SUPER_MAGIC
-			dont_measure fsmagic=0x27e0eb
-			dont_appraise fsmagic=0x27e0eb
-			# NSFS_MAGIC
-			dont_measure fsmagic=0x6e736673
-			dont_appraise fsmagic=0x6e736673
+		  default policy:
+			  # PROC_SUPER_MAGIC
+			  dont_measure fsmagic=0x9fa0
+			  dont_appraise fsmagic=0x9fa0
+			  # SYSFS_MAGIC
+			  dont_measure fsmagic=0x62656572
+			  dont_appraise fsmagic=0x62656572
+			  # DEBUGFS_MAGIC
+			  dont_measure fsmagic=0x64626720
+			  dont_appraise fsmagic=0x64626720
+			  # TMPFS_MAGIC
+			  dont_measure fsmagic=0x01021994
+			  dont_appraise fsmagic=0x01021994
+			  # RAMFS_MAGIC
+			  dont_appraise fsmagic=0x858458f6
+			  # DEVPTS_SUPER_MAGIC
+			  dont_measure fsmagic=0x1cd1
+			  dont_appraise fsmagic=0x1cd1
+			  # BINFMTFS_MAGIC
+			  dont_measure fsmagic=0x42494e4d
+			  dont_appraise fsmagic=0x42494e4d
+			  # SECURITYFS_MAGIC
+			  dont_measure fsmagic=0x73636673
+			  dont_appraise fsmagic=0x73636673
+			  # SELINUX_MAGIC
+			  dont_measure fsmagic=0xf97cff8c
+			  dont_appraise fsmagic=0xf97cff8c
+			  # CGROUP_SUPER_MAGIC
+			  dont_measure fsmagic=0x27e0eb
+			  dont_appraise fsmagic=0x27e0eb
+			  # NSFS_MAGIC
+			  dont_measure fsmagic=0x6e736673
+			  dont_appraise fsmagic=0x6e736673
 
-			measure func=BPRM_CHECK
-			measure func=FILE_MMAP mask=MAY_EXEC
-			measure func=FILE_CHECK mask=MAY_READ uid=0
-			measure func=MODULE_CHECK
-			measure func=FIRMWARE_CHECK
-			appraise fowner=0
+			  measure func=BPRM_CHECK
+			  measure func=FILE_MMAP mask=MAY_EXEC
+			  measure func=FILE_CHECK mask=MAY_READ uid=0
+			  measure func=MODULE_CHECK
+			  measure func=FIRMWARE_CHECK
+			  appraise fowner=0
 
 		The default policy measures all executables in bprm_check,
 		all files mmapped executable in file_mmap, and all files
@@ -90,7 +92,8 @@ Description:
 
 		Examples of LSM specific definitions:
 
-		SELinux:
+		SELinux::
+
 			dont_measure obj_type=var_log_t
 			dont_appraise obj_type=var_log_t
 			dont_measure obj_type=auditd_log_t
@@ -98,10 +101,11 @@ Description:
 			measure subj_user=system_u func=FILE_CHECK mask=MAY_READ
 			measure subj_role=system_r func=FILE_CHECK mask=MAY_READ
 
-		Smack:
+		Smack::
+
 			measure subj_user=_ func=FILE_CHECK mask=MAY_READ
 
-		Example of measure rules using alternate PCRs:
+		Example of measure rules using alternate PCRs::
 
 			measure func=KEXEC_KERNEL_CHECK pcr=4
 			measure func=KEXEC_INITRAMFS_CHECK pcr=5
diff --git a/Documentation/ABI/testing/procfs-diskstats b/Documentation/ABI/testing/procfs-diskstats
index 2c44b4f1b060..0a5583278797 100644
--- a/Documentation/ABI/testing/procfs-diskstats
+++ b/Documentation/ABI/testing/procfs-diskstats
@@ -6,27 +6,31 @@ Description:
 		of block devices. Each line contains the following 14
 		fields:
 
-		 1 - major number
-		 2 - minor mumber
-		 3 - device name
-		 4 - reads completed successfully
-		 5 - reads merged
-		 6 - sectors read
-		 7 - time spent reading (ms)
-		 8 - writes completed
-		 9 - writes merged
-		10 - sectors written
-		11 - time spent writing (ms)
-		12 - I/Os currently in progress
-		13 - time spent doing I/Os (ms)
-		14 - weighted time spent doing I/Os (ms)
+		==  ===================================
+		 1  major number
+		 2  minor mumber
+		 3  device name
+		 4  reads completed successfully
+		 5  reads merged
+		 6  sectors read
+		 7  time spent reading (ms)
+		 8  writes completed
+		 9  writes merged
+		10  sectors written
+		11  time spent writing (ms)
+		12  I/Os currently in progress
+		13  time spent doing I/Os (ms)
+		14  weighted time spent doing I/Os (ms)
+		==  ===================================
 
 		Kernel 4.18+ appends four more fields for discard
 		tracking putting the total at 18:
 
-		15 - discards completed successfully
-		16 - discards merged
-		17 - sectors discarded
-		18 - time spent discarding
+		==  ===================================
+		15  discards completed successfully
+		16  discards merged
+		17  sectors discarded
+		18  time spent discarding
+		==  ===================================
 
 		For more details refer to Documentation/admin-guide/iostats.rst
diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index f8c7c7126bb1..cdb8cadf14b9 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -4,17 +4,21 @@ Contact:	Jerome Marchand <jmarchan@redhat.com>
 Description:
 		The /sys/block/<disk>/stat files displays the I/O
 		statistics of disk <disk>. They contain 11 fields:
-		 1 - reads completed successfully
-		 2 - reads merged
-		 3 - sectors read
-		 4 - time spent reading (ms)
-		 5 - writes completed
-		 6 - writes merged
-		 7 - sectors written
-		 8 - time spent writing (ms)
-		 9 - I/Os currently in progress
-		10 - time spent doing I/Os (ms)
-		11 - weighted time spent doing I/Os (ms)
+
+		==  ===================================
+		 1  reads completed successfully
+		 2  reads merged
+		 3  sectors read
+		 4  time spent reading (ms)
+		 5  writes completed
+		 6  writes merged
+		 7  sectors written
+		 8  time spent writing (ms)
+		 9  I/Os currently in progress
+		10  time spent doing I/Os (ms)
+		11  weighted time spent doing I/Os (ms)
+		==  ===================================
+
 		For more details refer Documentation/admin-guide/iostats.rst
 
 
diff --git a/Documentation/ABI/testing/sysfs-block-device b/Documentation/ABI/testing/sysfs-block-device
index 17f2bc7dd261..aa0fb500e3c9 100644
--- a/Documentation/ABI/testing/sysfs-block-device
+++ b/Documentation/ABI/testing/sysfs-block-device
@@ -8,11 +8,13 @@ Description:
 
 		It has the following valid values:
 
+		==	========================================================
 		0	OFF - the LED is not activated on activity
 		1	BLINK_ON - the LED blinks on every 10ms when activity is
 			detected.
 		2	BLINK_OFF - the LED is on when idle, and blinks off
 			every 10ms when activity is detected.
+		==	========================================================
 
 		Note that the user must turn sw_activity OFF it they wish to
 		control the activity LED via the em_message file.
diff --git a/Documentation/ABI/testing/sysfs-bus-acpi b/Documentation/ABI/testing/sysfs-bus-acpi
index e7898cfe5fb1..c78603497b97 100644
--- a/Documentation/ABI/testing/sysfs-bus-acpi
+++ b/Documentation/ABI/testing/sysfs-bus-acpi
@@ -67,14 +67,16 @@ Description:
 		The return value is a decimal integer representing the device's
 		status bitmap:
 
-		Bit [0] –  Set if the device is present.
-		Bit [1] –  Set if the device is enabled and decoding its
-		           resources.
-		Bit [2] –  Set if the device should be shown in the UI.
-		Bit [3] –  Set if the device is functioning properly (cleared if
-		           device failed its diagnostics).
-		Bit [4] –  Set if the battery is present.
-		Bits [31:5] –  Reserved (must be cleared)
+		===========  ==================================================
+		Bit [0]      Set if the device is present.
+		Bit [1]      Set if the device is enabled and decoding its
+		             resources.
+		Bit [2]      Set if the device should be shown in the UI.
+		Bit [3]      Set if the device is functioning properly (cleared
+			     if device failed its diagnostics).
+		Bit [4]      Set if the battery is present.
+		Bits [31:5]  Reserved (must be cleared)
+		===========  ==================================================
 
 		If bit [0] is clear, then bit 1 must also be clear (a device
 		that is not present cannot be enabled).
diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
index 5bb793ec926c..df7ccc1b2fba 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
@@ -10,7 +10,8 @@ Description:
 		name/value pairs.
 
 		Userspace must be prepared for the possibility that attributes
-		define overlapping bit ranges. For example:
+		define overlapping bit ranges. For example::
+
 			attr1 = 'config:0-23'
 			attr2 = 'config:0-7'
 			attr3 = 'config:12-35'
diff --git a/Documentation/ABI/testing/sysfs-bus-i2c-devices-pca954x b/Documentation/ABI/testing/sysfs-bus-i2c-devices-pca954x
index 0b0de8cd0d13..b6c69eb80ca4 100644
--- a/Documentation/ABI/testing/sysfs-bus-i2c-devices-pca954x
+++ b/Documentation/ABI/testing/sysfs-bus-i2c-devices-pca954x
@@ -6,15 +6,18 @@ Description:
 		Value that exists only for mux devices that can be
 		written to control the behaviour of the multiplexer on
 		idle. Possible values:
-		-2 - disconnect on idle, i.e. deselect the last used
-		     channel, which is useful when there is a device
-		     with an address that conflicts with another
-		     device on another mux on the same parent bus.
-		-1 - leave the mux as-is, which is the most optimal
-		     setting in terms of I2C operations and is the
-		     default mode.
-		0..<nchans> - set the mux to a predetermined channel,
-		     which is useful if there is one channel that is
-		     used almost always, and you want to reduce the
-		     latency for normal operations after rare
-		     transactions on other channels
+
+		===========  ===============================================
+		-2	     disconnect on idle, i.e. deselect the last used
+			     channel, which is useful when there is a device
+			     with an address that conflicts with another
+			     device on another mux on the same parent bus.
+		-1	     leave the mux as-is, which is the most optimal
+			     setting in terms of I2C operations and is the
+			     default mode.
+		0..<nchans>  set the mux to a predetermined channel,
+			     which is useful if there is one channel that is
+			     used almost always, and you want to reduce the
+			     latency for normal operations after rare
+			     transactions on other channels
+		===========  ===============================================
diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 680451695422..2fb4f75860b3 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -63,6 +63,7 @@ Contact:	linux-iio@vger.kernel.org
 Description:
 		When the internal sampling clock can only take a specific set of
 		frequencies, we can specify the available values with:
+
 		- a small discrete set of values like "0 2 4 6 8"
 		- a range with minimum, step and maximum frequencies like
 		  "[min step max]"
@@ -1606,17 +1607,21 @@ Description:
 		Mounting matrix for IIO sensors. This is a rotation matrix which
 		informs userspace about sensor chip's placement relative to the
 		main hardware it is mounted on.
+
 		Main hardware placement is defined according to the local
 		reference frame related to the physical quantity the sensor
 		measures.
+
 		Given that the rotation matrix is defined in a board specific
 		way (platform data and / or device-tree), the main hardware
 		reference frame definition is left to the implementor's choice
 		(see below for a magnetometer example).
+
 		Applications should apply this rotation matrix to samples so
 		that when main hardware reference frame is aligned onto local
 		reference frame, then sensor chip reference frame is also
 		perfectly aligned with it.
+
 		Matrix is a 3x3 unitary matrix and typically looks like
 		[0, 1, 0; 1, 0, 0; 0, 0, -1]. Identity matrix
 		[1, 0, 0; 0, 1, 0; 0, 0, 1] means sensor chip and main hardware
@@ -1625,8 +1630,10 @@ Description:
 		For example, a mounting matrix for a magnetometer sensor informs
 		userspace about sensor chip's ORIENTATION relative to the main
 		hardware.
+
 		More specifically, main hardware orientation is defined with
 		respect to the LOCAL EARTH GEOMAGNETIC REFERENCE FRAME where :
+
 		* Y is in the ground plane and positive towards magnetic North ;
 		* X is in the ground plane, perpendicular to the North axis and
 		  positive towards the East ;
@@ -1635,13 +1642,16 @@ Description:
 		An implementor might consider that for a hand-held device, a
 		'natural' orientation would be 'front facing camera at the top'.
 		The main hardware reference frame could then be described as :
+
 		* Y is in the plane of the screen and is positive towards the
 		  top of the screen ;
 		* X is in the plane of the screen, perpendicular to Y axis, and
 		  positive towards the right hand side of the screen ;
 		* Z is perpendicular to the screen plane and positive out of the
 		  screen.
+
 		Another example for a quadrotor UAV might be :
+
 		* Y is in the plane of the propellers and positive towards the
 		  front-view camera;
 		* X is in the plane of the propellers, perpendicular to Y axis,
@@ -1683,6 +1693,7 @@ Description:
 		This interface is deprecated; please use the Counter subsystem.
 
 		A list of possible counting directions which are:
+
 		- "up"	: counter device is increasing.
 		- "down": counter device is decreasing.
 
diff --git a/Documentation/ABI/testing/sysfs-bus-iio-adc-envelope-detector b/Documentation/ABI/testing/sysfs-bus-iio-adc-envelope-detector
index 2071f9bcfaa5..1c2a07f7a75e 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-adc-envelope-detector
+++ b/Documentation/ABI/testing/sysfs-bus-iio-adc-envelope-detector
@@ -5,7 +5,8 @@ Contact:	Peter Rosin <peda@axentia.se>
 Description:
 		The DAC is used to find the peak level of an alternating
 		voltage input signal by a binary search using the output
-		of a comparator wired to an interrupt pin. Like so:
+		of a comparator wired to an interrupt pin. Like so::
+
 		                           _
 		                          | \
 		     input +------>-------|+ \
@@ -19,10 +20,12 @@ Description:
 		            |    irq|------<-------'
 		            |       |
 		            '-------'
+
 		The boolean invert attribute (0/1) should be set when the
 		input signal is centered around the maximum value of the
 		dac instead of zero. The envelope detector will search
 		from below in this case and will also invert the result.
+
 		The edge/level of the interrupt is also switched to its
 		opposite value.
 
diff --git a/Documentation/ABI/testing/sysfs-bus-iio-cros-ec b/Documentation/ABI/testing/sysfs-bus-iio-cros-ec
index 6158f831c761..adf24c40126f 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-cros-ec
+++ b/Documentation/ABI/testing/sysfs-bus-iio-cros-ec
@@ -4,7 +4,7 @@ KernelVersion:	4.7
 Contact:	linux-iio@vger.kernel.org
 Description:
 		Writing '1' will perform a FOC (Fast Online Calibration). The
-                corresponding calibration offsets can be read from *_calibbias
+                corresponding calibration offsets can be read from `*_calibbias`
                 entries.
 
 What:		/sys/bus/iio/devices/iio:deviceX/location
diff --git a/Documentation/ABI/testing/sysfs-bus-iio-dfsdm-adc-stm32 b/Documentation/ABI/testing/sysfs-bus-iio-dfsdm-adc-stm32
index da9822309f07..91439d6d60b5 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-dfsdm-adc-stm32
+++ b/Documentation/ABI/testing/sysfs-bus-iio-dfsdm-adc-stm32
@@ -3,14 +3,20 @@ KernelVersion:	4.14
 Contact:	arnaud.pouliquen@st.com
 Description:
 		For audio purpose only.
+
 		Used by audio driver to set/get the spi input frequency.
+
 		This is mandatory if DFSDM is slave on SPI bus, to
 		provide information on the SPI clock frequency during runtime
 		Notice that the SPI frequency should be a multiple of sample
 		frequency to ensure the precision.
-		if DFSDM input is SPI master
+
+		if DFSDM input is SPI master:
+
 			Reading  SPI clkout frequency,
 			error on writing
+
 		If DFSDM input is SPI Slave:
+
 			Reading returns value previously set.
-			Writing value before starting conversions.
\ No newline at end of file
+			Writing value before starting conversions.
diff --git a/Documentation/ABI/testing/sysfs-bus-iio-lptimer-stm32 b/Documentation/ABI/testing/sysfs-bus-iio-lptimer-stm32
index ad2cc63e4bf8..73498ff666bd 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-lptimer-stm32
+++ b/Documentation/ABI/testing/sysfs-bus-iio-lptimer-stm32
@@ -17,9 +17,11 @@ KernelVersion:	4.13
 Contact:	fabrice.gasnier@st.com
 Description:
 		Configure the device counter quadrature modes:
+
 		- non-quadrature:
 			Encoder IN1 input servers as the count input (up
 			direction).
+
 		- quadrature:
 			Encoder IN1 and IN2 inputs are mixed to get direction
 			and count.
@@ -35,23 +37,26 @@ KernelVersion:	4.13
 Contact:	fabrice.gasnier@st.com
 Description:
 		Configure the device encoder/counter active edge:
+
 		- rising-edge
 		- falling-edge
 		- both-edges
 
 		In non-quadrature mode, device counts up on active edge.
+
 		In quadrature mode, encoder counting scenarios are as follows:
-		----------------------------------------------------------------
+
+		+---------+----------+--------------------+--------------------+
 		| Active  | Level on |      IN1 signal    |     IN2 signal     |
-		| edge    | opposite |------------------------------------------
+		| edge    | opposite +----------+---------+----------+---------+
 		|         | signal   |  Rising  | Falling |  Rising  | Falling |
-		----------------------------------------------------------------
-		| Rising  | High ->  |   Down   |    -    |    Up    |    -    |
-		| edge    | Low  ->  |    Up    |    -    |   Down   |    -    |
-		----------------------------------------------------------------
-		| Falling | High ->  |    -     |    Up   |    -     |   Down  |
-		| edge    | Low  ->  |    -     |   Down  |    -     |    Up   |
-		----------------------------------------------------------------
-		| Both    | High ->  |   Down   |    Up   |    Up    |   Down  |
-		| edges   | Low  ->  |    Up    |   Down  |   Down   |    Up   |
-		----------------------------------------------------------------
+		+---------+----------+----------+---------+----------+---------+
+		| Rising  | High ->  |   Down   |    -    |   Up     |    -    |
+		| edge    | Low  ->  |   Up     |    -    |   Down   |    -    |
+		+---------+----------+----------+---------+----------+---------+
+		| Falling | High ->  |    -     |   Up    |    -     |   Down  |
+		| edge    | Low  ->  |    -     |   Down  |    -     |   Up    |
+		+---------+----------+----------+---------+----------+---------+
+		| Both    | High ->  |   Down   |   Up    |   Up     |   Down  |
+		| edges   | Low  ->  |   Up     |   Down  |   Down   |   Up    |
+		+---------+----------+----------+---------+----------+---------+
diff --git a/Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843 b/Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843
index 6275e9f56e6c..13f099ef6a95 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843
+++ b/Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843
@@ -5,11 +5,16 @@ Contact:        linux-iio@vger.kernel.org
 Description:
                 Current configuration and available configurations
 		for the bias current.
-		normal		- Normal measurement configurations (default)
-		positivebias	- Positive bias configuration
-		negativebias	- Negative bias configuration
-		disabled	- Only available on HMC5983. Disables magnetic
+
+		============	  ============================================
+		normal		  Normal measurement configurations (default)
+		positivebias	  Positive bias configuration
+		negativebias	  Negative bias configuration
+		disabled	  Only available on HMC5983. Disables magnetic
 				  sensor and enables temperature sensor.
-		Note: The effect of this configuration may vary
-		according to the device. For exact documentation
-		check the device's datasheet.
+		============	  ============================================
+
+		Note:
+		  The effect of this configuration may vary
+		  according to the device. For exact documentation
+		  check the device's datasheet.
diff --git a/Documentation/ABI/testing/sysfs-bus-iio-temperature-max31856 b/Documentation/ABI/testing/sysfs-bus-iio-temperature-max31856
index 3b3509a3ef2f..e5ef6d8e5da1 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-temperature-max31856
+++ b/Documentation/ABI/testing/sysfs-bus-iio-temperature-max31856
@@ -5,9 +5,12 @@ Description:
 		Open-circuit fault. The detection of open-circuit faults,
 		such as those caused by broken thermocouple wires.
 		Reading returns either '1' or '0'.
-		'1' = An open circuit such as broken thermocouple wires
-		      has been detected.
-		'0' = No open circuit or broken thermocouple wires are detected
+
+		===  =======================================================
+		'1'  An open circuit such as broken thermocouple wires
+		     has been detected.
+		'0'  No open circuit or broken thermocouple wires are detected
+		===  =======================================================
 
 What:		/sys/bus/iio/devices/iio:deviceX/fault_ovuv
 KernelVersion:	5.1
@@ -18,7 +21,11 @@ Description:
 		cables by integrated MOSFETs at the T+ and T- inputs, and the
 		BIAS output. These MOSFETs turn off when the input voltage is
 		negative or greater than VDD.
+
 		Reading returns either '1' or '0'.
-		'1' = The input voltage is negative or greater than VDD.
-		'0' = The input voltage is positive and less than VDD (normal
-		state).
+
+		===  =======================================================
+		'1'  The input voltage is negative or greater than VDD.
+		'0'  The input voltage is positive and less than VDD (normal
+		     state).
+		===  =======================================================
diff --git a/Documentation/ABI/testing/sysfs-bus-iio-timer-stm32 b/Documentation/ABI/testing/sysfs-bus-iio-timer-stm32
index 161c147d3c40..a10a4de3e5fe 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio-timer-stm32
+++ b/Documentation/ABI/testing/sysfs-bus-iio-timer-stm32
@@ -3,67 +3,85 @@ KernelVersion:	4.11
 Contact:	benjamin.gaignard@st.com
 Description:
 		Reading returns the list possible master modes which are:
-		- "reset"     :	The UG bit from the TIMx_EGR register is
+
+
+		- "reset"
+				The UG bit from the TIMx_EGR register is
 				used as trigger output (TRGO).
-		- "enable"    : The Counter Enable signal CNT_EN is used
+		- "enable"
+				The Counter Enable signal CNT_EN is used
 				as trigger output.
-		- "update"    : The update event is selected as trigger output.
+		- "update"
+				The update event is selected as trigger output.
 				For instance a master timer can then be used
 				as a prescaler for a slave timer.
-		- "compare_pulse" : The trigger output send a positive pulse
-				    when the CC1IF flag is to be set.
-		- "OC1REF"    : OC1REF signal is used as trigger output.
-		- "OC2REF"    : OC2REF signal is used as trigger output.
-		- "OC3REF"    : OC3REF signal is used as trigger output.
-		- "OC4REF"    : OC4REF signal is used as trigger output.
+		- "compare_pulse"
+				The trigger output send a positive pulse
+				when the CC1IF flag is to be set.
+		- "OC1REF"
+				OC1REF signal is used as trigger output.
+		- "OC2REF"
+				OC2REF signal is used as trigger output.
+		- "OC3REF"
+				OC3REF signal is used as trigger output.
+		- "OC4REF"
+				OC4REF signal is used as trigger output.
+
 		Additional modes (on TRGO2 only):
-		- "OC5REF"    : OC5REF signal is used as trigger output.
-		- "OC6REF"    : OC6REF signal is used as trigger output.
+
+		- "OC5REF"
+				OC5REF signal is used as trigger output.
+		- "OC6REF"
+				OC6REF signal is used as trigger output.
 		- "compare_pulse_OC4REF":
-		  OC4REF rising or falling edges generate pulses.
+				OC4REF rising or falling edges generate pulses.
 		- "compare_pulse_OC6REF":
-		  OC6REF rising or falling edges generate pulses.
+				OC6REF rising or falling edges generate pulses.
 		- "compare_pulse_OC4REF_r_or_OC6REF_r":
-		  OC4REF or OC6REF rising edges generate pulses.
+				OC4REF or OC6REF rising edges generate pulses.
 		- "compare_pulse_OC4REF_r_or_OC6REF_f":
-		  OC4REF rising or OC6REF falling edges generate pulses.
+				OC4REF rising or OC6REF falling edges generate
+				pulses.
 		- "compare_pulse_OC5REF_r_or_OC6REF_r":
-		  OC5REF or OC6REF rising edges generate pulses.
+				OC5REF or OC6REF rising edges generate pulses.
 		- "compare_pulse_OC5REF_r_or_OC6REF_f":
-		  OC5REF rising or OC6REF falling edges generate pulses.
+				OC5REF rising or OC6REF falling edges generate
+				pulses.
 
-		+-----------+   +-------------+            +---------+
-		| Prescaler +-> | Counter     |        +-> | Master  | TRGO(2)
-		+-----------+   +--+--------+-+        |-> | Control +-->
-		                   |        |          ||  +---------+
-		                +--v--------+-+ OCxREF ||  +---------+
-		                | Chx compare +----------> | Output  | ChX
-		                +-----------+-+         |  | Control +-->
-		                      .     |           |  +---------+
-		                      .     |           |    .
-		                +-----------v-+ OC6REF  |    .
-		                | Ch6 compare +---------+>
-		                +-------------+
+		::
 
-		Example with: "compare_pulse_OC4REF_r_or_OC6REF_r":
+		  +-----------+   +-------------+            +---------+
+		  | Prescaler +-> | Counter     |        +-> | Master  | TRGO(2)
+		  +-----------+   +--+--------+-+        |-> | Control +-->
+		                     |        |          ||  +---------+
+		                  +--v--------+-+ OCxREF ||  +---------+
+		                  | Chx compare +----------> | Output  | ChX
+		                  +-----------+-+         |  | Control +-->
+		                        .     |           |  +---------+
+		                        .     |           |    .
+		                  +-----------v-+ OC6REF  |    .
+		                  | Ch6 compare +---------+>
+		                  +-------------+
 
-		                X
-		              X   X
-		            X .   . X
-		          X   .   .   X
-		        X     .   .     X
-		count X .     .   .     . X
-		        .     .   .     .
-		        .     .   .     .
-		        +---------------+
-		OC4REF  |     .   .     |
-		      +-+     .   .     +-+
-		        .     +---+     .
-		OC6REF  .     |   |     .
-		      +-------+   +-------+
-		        +-+   +-+
-		TRGO2   | |   | |
-		      +-+ +---+ +---------+
+		Example with: "compare_pulse_OC4REF_r_or_OC6REF_r"::
+
+		                  X
+		                X   X
+		              X .   . X
+		            X   .   .   X
+		          X     .   .     X
+		  count X .     .   .     . X
+		          .     .   .     .
+		          .     .   .     .
+		          +---------------+
+		  OC4REF  |     .   .     |
+		        +-+     .   .     +-+
+		          .     +---+     .
+		  OC6REF  .     |   |     .
+		        +-------+   +-------+
+		          +-+   +-+
+		  TRGO2   | |   | |
+		        +-+ +---+ +---------+
 
 What:		/sys/bus/iio/devices/triggerX/master_mode
 KernelVersion:	4.11
@@ -102,6 +120,7 @@ KernelVersion:	4.12
 Contact:	benjamin.gaignard@st.com
 Description:
 		Configure the device counter quadrature modes:
+
 		channel_A:
 			Encoder A input servers as the count input and B as
 			the UP/DOWN direction control input.
@@ -127,6 +146,7 @@ Description:
 		Configure the device counter enable modes, in all case
 		counting direction is set by in_count0_count_direction
 		attribute and the counter is clocked by the internal clock.
+
 		always:
 			Counter is always ON.
 
diff --git a/Documentation/ABI/testing/sysfs-bus-intel_th-devices-msc b/Documentation/ABI/testing/sysfs-bus-intel_th-devices-msc
index f54ae244f3f1..345049b97f09 100644
--- a/Documentation/ABI/testing/sysfs-bus-intel_th-devices-msc
+++ b/Documentation/ABI/testing/sysfs-bus-intel_th-devices-msc
@@ -9,10 +9,12 @@ Date:		June 2015
 KernelVersion:	4.3
 Contact:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
 Description:	(RW) Configure MSC operating mode:
+
 		  - "single", for contiguous buffer mode (high-order alloc);
 		  - "multi", for multiblock mode;
 		  - "ExI", for DCI handler mode;
 		  - "debug", for debug mode.
+
 		If operating mode changes, existing buffer is deallocated,
 		provided there are no active users and tracing is not enabled,
 		otherwise the write will fail.
@@ -22,10 +24,12 @@ Date:		June 2015
 KernelVersion:	4.3
 Contact:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
 Description:	(RW) Configure MSC buffer size for "single" or "multi" modes.
+
 		In single mode, this is a single number of pages, has to be
 		power of 2. In multiblock mode, this is a comma-separated list
 		of numbers of pages for each window to be allocated. Number of
 		windows is not limited.
+
 		Writing to this file deallocates existing buffer (provided
 		there are no active users and tracing is not enabled) and then
 		allocates a new one.
diff --git a/Documentation/ABI/testing/sysfs-bus-nfit b/Documentation/ABI/testing/sysfs-bus-nfit
index a1cb44dcb908..264a2c9d0d6c 100644
--- a/Documentation/ABI/testing/sysfs-bus-nfit
+++ b/Documentation/ABI/testing/sysfs-bus-nfit
@@ -1,4 +1,4 @@
-For all of the nmem device attributes under nfit/*, see the 'NVDIMM Firmware
+For all of the nmem device attributes under ``nfit/*``, see the 'NVDIMM Firmware
 Interface Table (NFIT)' section in the ACPI specification
 (http://www.uefi.org/specifications) for more details.
 
diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-aer_stats b/Documentation/ABI/testing/sysfs-bus-pci-devices-aer_stats
index 3c9a8c4a25eb..860db53037a5 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci-devices-aer_stats
+++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-aer_stats
@@ -1,6 +1,6 @@
-==========================
 PCIe Device AER statistics
-==========================
+--------------------------
+
 These attributes show up under all the devices that are AER capable. These
 statistical counters indicate the errors "as seen/reported by the device".
 Note that this may mean that if an endpoint is causing problems, the AER
@@ -17,19 +17,18 @@ Description:	List of correctable errors seen and reported by this
 		PCI device using ERR_COR. Note that since multiple errors may
 		be reported using a single ERR_COR message, thus
 		TOTAL_ERR_COR at the end of the file may not match the actual
-		total of all the errors in the file. Sample output:
--------------------------------------------------------------------------
-localhost /sys/devices/pci0000:00/0000:00:1c.0 # cat aer_dev_correctable
-Receiver Error 2
-Bad TLP 0
-Bad DLLP 0
-RELAY_NUM Rollover 0
-Replay Timer Timeout 0
-Advisory Non-Fatal 0
-Corrected Internal Error 0
-Header Log Overflow 0
-TOTAL_ERR_COR 2
--------------------------------------------------------------------------
+		total of all the errors in the file. Sample output::
+
+		    localhost /sys/devices/pci0000:00/0000:00:1c.0 # cat aer_dev_correctable
+		    Receiver Error 2
+		    Bad TLP 0
+		    Bad DLLP 0
+		    RELAY_NUM Rollover 0
+		    Replay Timer Timeout 0
+		    Advisory Non-Fatal 0
+		    Corrected Internal Error 0
+		    Header Log Overflow 0
+		    TOTAL_ERR_COR 2
 
 What:		/sys/bus/pci/devices/<dev>/aer_dev_fatal
 Date:		July 2018
@@ -39,28 +38,27 @@ Description:	List of uncorrectable fatal errors seen and reported by this
 		PCI device using ERR_FATAL. Note that since multiple errors may
 		be reported using a single ERR_FATAL message, thus
 		TOTAL_ERR_FATAL at the end of the file may not match the actual
-		total of all the errors in the file. Sample output:
--------------------------------------------------------------------------
-localhost /sys/devices/pci0000:00/0000:00:1c.0 # cat aer_dev_fatal
-Undefined 0
-Data Link Protocol 0
-Surprise Down Error 0
-Poisoned TLP 0
-Flow Control Protocol 0
-Completion Timeout 0
-Completer Abort 0
-Unexpected Completion 0
-Receiver Overflow 0
-Malformed TLP 0
-ECRC 0
-Unsupported Request 0
-ACS Violation 0
-Uncorrectable Internal Error 0
-MC Blocked TLP 0
-AtomicOp Egress Blocked 0
-TLP Prefix Blocked Error 0
-TOTAL_ERR_FATAL 0
--------------------------------------------------------------------------
+		total of all the errors in the file. Sample output::
+
+		    localhost /sys/devices/pci0000:00/0000:00:1c.0 # cat aer_dev_fatal
+		    Undefined 0
+		    Data Link Protocol 0
+		    Surprise Down Error 0
+		    Poisoned TLP 0
+		    Flow Control Protocol 0
+		    Completion Timeout 0
+		    Completer Abort 0
+		    Unexpected Completion 0
+		    Receiver Overflow 0
+		    Malformed TLP 0
+		    ECRC 0
+		    Unsupported Request 0
+		    ACS Violation 0
+		    Uncorrectable Internal Error 0
+		    MC Blocked TLP 0
+		    AtomicOp Egress Blocked 0
+		    TLP Prefix Blocked Error 0
+		    TOTAL_ERR_FATAL 0
 
 What:		/sys/bus/pci/devices/<dev>/aer_dev_nonfatal
 Date:		July 2018
@@ -70,32 +68,31 @@ Description:	List of uncorrectable nonfatal errors seen and reported by this
 		PCI device using ERR_NONFATAL. Note that since multiple errors
 		may be reported using a single ERR_FATAL message, thus
 		TOTAL_ERR_NONFATAL at the end of the file may not match the
-		actual total of all the errors in the file. Sample output:
--------------------------------------------------------------------------
-localhost /sys/devices/pci0000:00/0000:00:1c.0 # cat aer_dev_nonfatal
-Undefined 0
-Data Link Protocol 0
-Surprise Down Error 0
-Poisoned TLP 0
-Flow Control Protocol 0
-Completion Timeout 0
-Completer Abort 0
-Unexpected Completion 0
-Receiver Overflow 0
-Malformed TLP 0
-ECRC 0
-Unsupported Request 0
-ACS Violation 0
-Uncorrectable Internal Error 0
-MC Blocked TLP 0
-AtomicOp Egress Blocked 0
-TLP Prefix Blocked Error 0
-TOTAL_ERR_NONFATAL 0
--------------------------------------------------------------------------
+		actual total of all the errors in the file. Sample output::
+
+		    localhost /sys/devices/pci0000:00/0000:00:1c.0 # cat aer_dev_nonfatal
+		    Undefined 0
+		    Data Link Protocol 0
+		    Surprise Down Error 0
+		    Poisoned TLP 0
+		    Flow Control Protocol 0
+		    Completion Timeout 0
+		    Completer Abort 0
+		    Unexpected Completion 0
+		    Receiver Overflow 0
+		    Malformed TLP 0
+		    ECRC 0
+		    Unsupported Request 0
+		    ACS Violation 0
+		    Uncorrectable Internal Error 0
+		    MC Blocked TLP 0
+		    AtomicOp Egress Blocked 0
+		    TLP Prefix Blocked Error 0
+		    TOTAL_ERR_NONFATAL 0
 
-============================
 PCIe Rootport AER statistics
-============================
+----------------------------
+
 These attributes show up under only the rootports (or root complex event
 collectors) that are AER capable. These indicate the number of error messages as
 "reported to" the rootport. Please note that the rootports also transmit
diff --git a/Documentation/ABI/testing/sysfs-bus-rapidio b/Documentation/ABI/testing/sysfs-bus-rapidio
index 13208b27dd87..634ea207a50a 100644
--- a/Documentation/ABI/testing/sysfs-bus-rapidio
+++ b/Documentation/ABI/testing/sysfs-bus-rapidio
@@ -4,24 +4,27 @@ Description:
 		an individual subdirectory with the following name format of
 		device_name "nn:d:iiii", where:
 
-		nn   - two-digit hexadecimal ID of RapidIO network where the
+		====   ========================================================
+		nn     two-digit hexadecimal ID of RapidIO network where the
 		       device resides
-		d    - device type: 'e' - for endpoint or 's' - for switch
-		iiii - four-digit device destID for endpoints, or switchID for
+		d      device type: 'e' - for endpoint or 's' - for switch
+		iiii   four-digit device destID for endpoints, or switchID for
 		       switches
+		====   ========================================================
 
 		For example, below is a list of device directories that
 		represents a typical RapidIO network with one switch, one host,
 		and two agent endpoints, as it is seen by the enumerating host
-		(with destID = 1):
+		(with destID = 1)::
 
-		/sys/bus/rapidio/devices/00:e:0000
-		/sys/bus/rapidio/devices/00:e:0002
-		/sys/bus/rapidio/devices/00:s:0001
+		  /sys/bus/rapidio/devices/00:e:0000
+		  /sys/bus/rapidio/devices/00:e:0002
+		  /sys/bus/rapidio/devices/00:s:0001
 
-		NOTE: An enumerating or discovering endpoint does not create a
-		sysfs entry for itself, this is why an endpoint with destID=1 is
-		not shown in the list.
+		NOTE:
+		  An enumerating or discovering endpoint does not create a
+		  sysfs entry for itself, this is why an endpoint with destID=1
+		  is not shown in the list.
 
 Attributes Common for All RapidIO Devices
 -----------------------------------------
diff --git a/Documentation/ABI/testing/sysfs-bus-thunderbolt b/Documentation/ABI/testing/sysfs-bus-thunderbolt
index b21fba14689b..ffb2c3759ffd 100644
--- a/Documentation/ABI/testing/sysfs-bus-thunderbolt
+++ b/Documentation/ABI/testing/sysfs-bus-thunderbolt
@@ -37,16 +37,18 @@ Contact:	thunderbolt-software@lists.01.org
 Description:	This attribute holds current Thunderbolt security level
 		set by the system BIOS. Possible values are:
 
-		none: All devices are automatically authorized
-		user: Devices are only authorized based on writing
-		      appropriate value to the authorized attribute
-		secure: Require devices that support secure connect at
-			minimum. User needs to authorize each device.
-		dponly: Automatically tunnel Display port (and USB). No
-			PCIe tunnels are created.
-		usbonly: Automatically tunnel USB controller of the
+		=======  ==================================================
+		none     All devices are automatically authorized
+		user     Devices are only authorized based on writing
+		         appropriate value to the authorized attribute
+		secure   Require devices that support secure connect at
+			 minimum. User needs to authorize each device.
+		dponly   Automatically tunnel Display port (and USB). No
+			 PCIe tunnels are created.
+		usbonly  Automatically tunnel USB controller of the
 			 connected Thunderbolt dock (and Display Port). All
 			 PCIe links downstream of the dock are removed.
+		=======  ==================================================
 
 What: /sys/bus/thunderbolt/devices/.../authorized
 Date:		Sep 2017
@@ -61,17 +63,23 @@ Description:	This attribute is used to authorize Thunderbolt devices
 		yet authorized.
 
 		Possible values are supported:
-		1: The device will be authorized and connected
+
+		==  ===========================================
+		1   The device will be authorized and connected
+		==  ===========================================
 
 		When key attribute contains 32 byte hex string the possible
 		values are:
-		1: The 32 byte hex string is added to the device NVM and
-		   the device is authorized.
-		2: Send a challenge based on the 32 byte hex string. If the
-		   challenge response from device is valid, the device is
-		   authorized. In case of failure errno will be ENOKEY if
-		   the device did not contain a key at all, and
-		   EKEYREJECTED if the challenge response did not match.
+
+		==  ========================================================
+		1   The 32 byte hex string is added to the device NVM and
+		    the device is authorized.
+		2   Send a challenge based on the 32 byte hex string. If the
+		    challenge response from device is valid, the device is
+		    authorized. In case of failure errno will be ENOKEY if
+		    the device did not contain a key at all, and
+		    EKEYREJECTED if the challenge response did not match.
+		==  ========================================================
 
 What: /sys/bus/thunderbolt/devices/.../boot
 Date:		Jun 2018
diff --git a/Documentation/ABI/testing/sysfs-bus-usb b/Documentation/ABI/testing/sysfs-bus-usb
index 614d216dff1d..e449b8374f6a 100644
--- a/Documentation/ABI/testing/sysfs-bus-usb
+++ b/Documentation/ABI/testing/sysfs-bus-usb
@@ -72,24 +72,27 @@ Description:
 		table at compile time. The format for the device ID is:
 		idVendor idProduct bInterfaceClass RefIdVendor RefIdProduct
 		The vendor ID and device ID fields are required, the
-		rest is optional. The Ref* tuple can be used to tell the
+		rest is optional. The `Ref*` tuple can be used to tell the
 		driver to use the same driver_data for the new device as
 		it is used for the reference device.
 		Upon successfully adding an ID, the driver will probe
-		for the device and attempt to bind to it.  For example:
-		# echo "8086 10f5" > /sys/bus/usb/drivers/foo/new_id
+		for the device and attempt to bind to it.  For example::
+
+		  # echo "8086 10f5" > /sys/bus/usb/drivers/foo/new_id
 
 		Here add a new device (0458:7045) using driver_data from
-		an already supported device (0458:704c):
-		# echo "0458 7045 0 0458 704c" > /sys/bus/usb/drivers/foo/new_id
+		an already supported device (0458:704c)::
+
+		  # echo "0458 7045 0 0458 704c" > /sys/bus/usb/drivers/foo/new_id
 
 		Reading from this file will list all dynamically added
 		device IDs in the same format, with one entry per
-		line. For example:
-		# cat /sys/bus/usb/drivers/foo/new_id
-		8086 10f5
-		dead beef 06
-		f00d cafe
+		line. For example::
+
+		  # cat /sys/bus/usb/drivers/foo/new_id
+		  8086 10f5
+		  dead beef 06
+		  f00d cafe
 
 		The list will be truncated at PAGE_SIZE bytes due to
 		sysfs restrictions.
@@ -209,6 +212,7 @@ Description:
 		advance, and behaves well according to the specification.
 		This attribute is a bit-field that controls the behavior of
 		a specific port:
+
 		 - Bit 0 of this field selects the "old" enumeration scheme,
 		   as it is considerably faster (it only causes one USB reset
 		   instead of 2).
@@ -233,10 +237,10 @@ Description:
 		poll() for monitoring changes to this value in user space.
 
 		Any time this value changes the corresponding hub device will send a
-		udev event with the following attributes:
+		udev event with the following attributes::
 
-		OVER_CURRENT_PORT=/sys/bus/usb/devices/.../(hub interface)/portX
-		OVER_CURRENT_COUNT=[current value of this sysfs attribute]
+		  OVER_CURRENT_PORT=/sys/bus/usb/devices/.../(hub interface)/portX
+		  OVER_CURRENT_COUNT=[current value of this sysfs attribute]
 
 What:		/sys/bus/usb/devices/.../(hub interface)/portX/usb3_lpm_permit
 Date:		November 2015
diff --git a/Documentation/ABI/testing/sysfs-bus-usb-devices-usbsevseg b/Documentation/ABI/testing/sysfs-bus-usb-devices-usbsevseg
index 9ade80f81f96..2f86e4223bfc 100644
--- a/Documentation/ABI/testing/sysfs-bus-usb-devices-usbsevseg
+++ b/Documentation/ABI/testing/sysfs-bus-usb-devices-usbsevseg
@@ -12,8 +12,11 @@ KernelVersion:	2.6.26
 Contact:	Harrison Metzger <harrisonmetz@gmail.com>
 Description:	Controls the devices display mode.
 		For a 6 character display the values are
+
 			MSB 0x06; LSB 0x3F, and
+
 		for an 8 character display the values are
+
 			MSB 0x08; LSB 0xFF.
 
 What:		/sys/bus/usb/.../textmode
@@ -37,7 +40,7 @@ KernelVersion:	2.6.26
 Contact:	Harrison Metzger <harrisonmetz@gmail.com>
 Description:	Controls the decimal places on the device.
 		To set the nth decimal place, give this field
-		the value of 10 ** n. Assume this field has
+		the value of ``10 ** n``. Assume this field has
 		the value k and has 1 or more decimal places set,
 		to set the mth place (where m is not already set),
-		change this fields value to k + 10 ** m.
+		change this fields value to ``k + 10 ** m``.
diff --git a/Documentation/ABI/testing/sysfs-bus-vfio-mdev b/Documentation/ABI/testing/sysfs-bus-vfio-mdev
index 452dbe39270e..59fc804265db 100644
--- a/Documentation/ABI/testing/sysfs-bus-vfio-mdev
+++ b/Documentation/ABI/testing/sysfs-bus-vfio-mdev
@@ -28,8 +28,9 @@ Description:
 		Writing UUID to this file will create mediated device of
 		type <type-id> for parent device <device>. This is a
 		write-only file.
-		For example:
-		# echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1001" >	\
+		For example::
+
+		  # echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1001" >	\
 		       /sys/devices/foo/mdev_supported_types/foo-1/create
 
 What:           /sys/.../mdev_supported_types/<type-id>/devices/
@@ -107,5 +108,6 @@ Description:
 		Writing '1' to this file destroys the mediated device. The
 		vendor driver can fail the remove() callback if that device
 		is active and the vendor driver doesn't support hot unplug.
-		Example:
-		# echo 1 > /sys/bus/mdev/devices/<UUID>/remove
+		Example::
+
+		  # echo 1 > /sys/bus/mdev/devices/<UUID>/remove
diff --git a/Documentation/ABI/testing/sysfs-class-cxl b/Documentation/ABI/testing/sysfs-class-cxl
index 7970e3713e70..a6f51a104c44 100644
--- a/Documentation/ABI/testing/sysfs-class-cxl
+++ b/Documentation/ABI/testing/sysfs-class-cxl
@@ -72,11 +72,16 @@ Description:    read/write
                 when performing the START_WORK ioctl. Only applicable when
                 running under hashed page table mmu.
                 Possible values:
-                        none: No prefaulting (default)
-                        work_element_descriptor: Treat the work element
-                                 descriptor as an effective address and
-                                 prefault what it points to.
-                        all: all segments process calling START_WORK maps.
+
+                =======================  ======================================
+		none			 No prefaulting (default)
+		work_element_descriptor  Treat the work element
+					 descriptor as an effective address and
+					 prefault what it points to.
+                all			 all segments process calling
+					 START_WORK maps.
+                =======================  ======================================
+
 Users:		https://github.com/ibm-capi/libcxl
 
 What:           /sys/class/cxl/<afu>/reset
diff --git a/Documentation/ABI/testing/sysfs-class-led b/Documentation/ABI/testing/sysfs-class-led
index 5f67f7ab277b..65e040978f73 100644
--- a/Documentation/ABI/testing/sysfs-class-led
+++ b/Documentation/ABI/testing/sysfs-class-led
@@ -50,7 +50,7 @@ Description:
 		You can change triggers in a similar manner to the way an IO
 		scheduler is chosen. Trigger specific parameters can appear in
 		/sys/class/leds/<led> once a given trigger is selected. For
-		their documentation see sysfs-class-led-trigger-*.
+		their documentation see `sysfs-class-led-trigger-*`.
 
 What:		/sys/class/leds/<led>/inverted
 Date:		January 2011
diff --git a/Documentation/ABI/testing/sysfs-class-mic.txt b/Documentation/ABI/testing/sysfs-class-mic.txt
index 6ef682603179..bd0e780c3760 100644
--- a/Documentation/ABI/testing/sysfs-class-mic.txt
+++ b/Documentation/ABI/testing/sysfs-class-mic.txt
@@ -41,24 +41,33 @@ Description:
 		When read, this entry provides the current state of an Intel
 		MIC device in the context of the card OS. Possible values that
 		will be read are:
-		"ready" - The MIC device is ready to boot the card OS. On
-		reading this entry after an OSPM resume, a "boot" has to be
-		written to this entry if the card was previously shutdown
-		during OSPM suspend.
-		"booting" - The MIC device has initiated booting a card OS.
-		"online" - The MIC device has completed boot and is online
-		"shutting_down" - The card OS is shutting down.
-		"resetting" - A reset has been initiated for the MIC device
-		"reset_failed" - The MIC device has failed to reset.
+
+
+		===============  ===============================================
+		"ready"		 The MIC device is ready to boot the card OS.
+				 On reading this entry after an OSPM resume,
+				 a "boot" has to be written to this entry if
+				 the card was previously shutdown during OSPM
+				 suspend.
+		"booting"	 The MIC device has initiated booting a card OS.
+		"online"	 The MIC device has completed boot and is online
+		"shutting_down"	 The card OS is shutting down.
+		"resetting"	 A reset has been initiated for the MIC device
+		"reset_failed"	 The MIC device has failed to reset.
+		===============  ===============================================
 
 		When written, this sysfs entry triggers different state change
 		operations depending upon the current state of the card OS.
 		Acceptable values are:
-		"boot" - Boot the card OS image specified by the combination
-			 of firmware, ramdisk, cmdline and bootmode
-			sysfs entries.
-		"reset" - Initiates device reset.
-		"shutdown" - Initiates card OS shutdown.
+
+
+		==========  ===================================================
+		"boot"      Boot the card OS image specified by the combination
+			    of firmware, ramdisk, cmdline and bootmode
+			    sysfs entries.
+		"reset"     Initiates device reset.
+		"shutdown"  Initiates card OS shutdown.
+		==========  ===================================================
 
 What:		/sys/class/mic/mic(x)/shutdown_status
 Date:		October 2013
@@ -69,12 +78,15 @@ Description:
 		OS can shutdown because of various reasons. When read, this
 		entry provides the status on why the card OS was shutdown.
 		Possible values are:
-		"nop" -  shutdown status is not applicable, when the card OS is
-			"online"
-		"crashed" - Shutdown because of a HW or SW crash.
-		"halted" - Shutdown because of a halt command.
-		"poweroff" - Shutdown because of a poweroff command.
-		"restart" - Shutdown because of a restart command.
+
+		==========  ===================================================
+		"nop"       shutdown status is not applicable, when the card OS
+			    is "online"
+		"crashed"   Shutdown because of a HW or SW crash.
+		"halted"    Shutdown because of a halt command.
+		"poweroff"  Shutdown because of a poweroff command.
+		"restart"   Shutdown because of a restart command.
+		==========  ===================================================
 
 What:		/sys/class/mic/mic(x)/cmdline
 Date:		October 2013
diff --git a/Documentation/ABI/testing/sysfs-class-ocxl b/Documentation/ABI/testing/sysfs-class-ocxl
index b5b1fa197592..97e404834d3a 100644
--- a/Documentation/ABI/testing/sysfs-class-ocxl
+++ b/Documentation/ABI/testing/sysfs-class-ocxl
@@ -11,8 +11,11 @@ Contact:	linuxppc-dev@lists.ozlabs.org
 Description:	read only
 		Number of contexts for the AFU, in the format <n>/<max>
 		where:
+
+			====	===============================================
 			n:	number of currently active contexts, for debug
 			max:	maximum number of contexts supported by the AFU
+			====	===============================================
 
 What:		/sys/class/ocxl/<afu name>/pp_mmio_size
 Date:		January 2018
diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/ABI/testing/sysfs-class-power
index 27edc06e2495..34f796b9cc87 100644
--- a/Documentation/ABI/testing/sysfs-class-power
+++ b/Documentation/ABI/testing/sysfs-class-power
@@ -1,4 +1,4 @@
-===== General Properties =====
+**General Properties**
 
 What:		/sys/class/power_supply/<supply_name>/manufacturer
 Date:		May 2007
@@ -72,6 +72,7 @@ Description:
 		critically low).
 
 		Access: Read, Write
+
 		Valid values: 0 - 100 (percent)
 
 What:		/sys/class/power_supply/<supply_name>/capacity_level
@@ -81,7 +82,9 @@ Description:
 		Coarse representation of battery capacity.
 
 		Access: Read
-		Valid values: "Unknown", "Critical", "Low", "Normal", "High",
+
+		Valid values:
+			      "Unknown", "Critical", "Low", "Normal", "High",
 			      "Full"
 
 What:		/sys/class/power_supply/<supply_name>/current_avg
@@ -122,6 +125,7 @@ Description:
 		throttling for thermal cooling or improving battery health.
 
 		Access: Read, Write
+
 		Valid values: Represented in microamps
 
 What:		/sys/class/power_supply/<supply_name>/charge_control_limit_max
@@ -131,6 +135,7 @@ Description:
 		Maximum legal value for the charge_control_limit property.
 
 		Access: Read
+
 		Valid values: Represented in microamps
 
 What:		/sys/class/power_supply/<supply_name>/charge_control_start_threshold
@@ -151,6 +156,7 @@ Description:
 		stop.
 
 		Access: Read, Write
+
 		Valid values: 0 - 100 (percent)
 
 What:		/sys/class/power_supply/<supply_name>/charge_type
@@ -166,7 +172,9 @@ Description:
 		different algorithm.
 
 		Access: Read, Write
-		Valid values: "Unknown", "N/A", "Trickle", "Fast", "Standard",
+
+		Valid values:
+			      "Unknown", "N/A", "Trickle", "Fast", "Standard",
 			      "Adaptive", "Custom"
 
 What:		/sys/class/power_supply/<supply_name>/charge_term_current
@@ -177,6 +185,7 @@ Description:
 		when the battery is considered full and charging should end.
 
 		Access: Read
+
 		Valid values: Represented in microamps
 
 What:		/sys/class/power_supply/<supply_name>/health
@@ -187,7 +196,9 @@ Description:
 		functionality.
 
 		Access: Read
-		Valid values: "Unknown", "Good", "Overheat", "Dead",
+
+		Valid values:
+			      "Unknown", "Good", "Overheat", "Dead",
 			      "Over voltage", "Unspecified failure", "Cold",
 			      "Watchdog timer expire", "Safety timer expire"
 
@@ -199,6 +210,7 @@ Description:
 		for a battery charge cycle.
 
 		Access: Read
+
 		Valid values: Represented in microamps
 
 What:		/sys/class/power_supply/<supply_name>/present
@@ -208,9 +220,13 @@ Description:
 		Reports whether a battery is present or not in the system.
 
 		Access: Read
+
 		Valid values:
+
+			== =======
 			0: Absent
 			1: Present
+			== =======
 
 What:		/sys/class/power_supply/<supply_name>/status
 Date:		May 2007
@@ -221,7 +237,9 @@ Description:
 		used to enable/disable charging to the battery.
 
 		Access: Read, Write
-		Valid values: "Unknown", "Charging", "Discharging",
+
+		Valid values:
+			      "Unknown", "Charging", "Discharging",
 			      "Not charging", "Full"
 
 What:		/sys/class/power_supply/<supply_name>/technology
@@ -231,7 +249,9 @@ Description:
 		Describes the battery technology supported by the supply.
 
 		Access: Read
-		Valid values: "Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe",
+
+		Valid values:
+			      "Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe",
 			      "NiCd", "LiMn"
 
 What:		/sys/class/power_supply/<supply_name>/temp
@@ -241,6 +261,7 @@ Description:
 		Reports the current TBAT battery temperature reading.
 
 		Access: Read
+
 		Valid values: Represented in 1/10 Degrees Celsius
 
 What:		/sys/class/power_supply/<supply_name>/temp_alert_max
@@ -255,6 +276,7 @@ Description:
 		critically high, and charging has stopped).
 
 		Access: Read
+
 		Valid values: Represented in 1/10 Degrees Celsius
 
 What:		/sys/class/power_supply/<supply_name>/temp_alert_min
@@ -270,6 +292,7 @@ Description:
 		remedy the situation).
 
 		Access: Read
+
 		Valid values: Represented in 1/10 Degrees Celsius
 
 What:		/sys/class/power_supply/<supply_name>/temp_max
@@ -280,6 +303,7 @@ Description:
 		charging.
 
 		Access: Read
+
 		Valid values: Represented in 1/10 Degrees Celsius
 
 What:		/sys/class/power_supply/<supply_name>/temp_min
@@ -290,6 +314,7 @@ Description:
 		charging.
 
 		Access: Read
+
 		Valid values: Represented in 1/10 Degrees Celsius
 
 What:		/sys/class/power_supply/<supply_name>/voltage_avg,
@@ -301,6 +326,7 @@ Description:
 		which they average readings to smooth out the reported value.
 
 		Access: Read
+
 		Valid values: Represented in microvolts
 
 What:		/sys/class/power_supply/<supply_name>/voltage_max,
@@ -311,6 +337,7 @@ Description:
 		during charging.
 
 		Access: Read
+
 		Valid values: Represented in microvolts
 
 What:		/sys/class/power_supply/<supply_name>/voltage_min,
@@ -321,6 +348,7 @@ Description:
 		during discharging.
 
 		Access: Read
+
 		Valid values: Represented in microvolts
 
 What:		/sys/class/power_supply/<supply_name>/voltage_now,
@@ -331,9 +359,10 @@ Description:
 		This value is not averaged/smoothed.
 
 		Access: Read
+
 		Valid values: Represented in microvolts
 
-===== USB Properties =====
+**USB Properties**
 
 What: 		/sys/class/power_supply/<supply_name>/current_avg
 Date:		May 2007
@@ -344,6 +373,7 @@ Description:
 		average readings to smooth out the reported value.
 
 		Access: Read
+
 		Valid values: Represented in microamps
 
 
@@ -354,6 +384,7 @@ Description:
 		Reports the maximum IBUS current the supply can support.
 
 		Access: Read
+
 		Valid values: Represented in microamps
 
 What: 		/sys/class/power_supply/<supply_name>/current_now
@@ -366,6 +397,7 @@ Description:
 		within the reported min/max range.
 
 		Access: Read, Write
+
 		Valid values: Represented in microamps
 
 What:		/sys/class/power_supply/<supply_name>/input_current_limit
@@ -380,6 +412,7 @@ Description:
 		solved using power limit use input_current_limit.
 
 		Access: Read, Write
+
 		Valid values: Represented in microamps
 
 What:		/sys/class/power_supply/<supply_name>/input_voltage_limit
@@ -422,10 +455,14 @@ Description:
 		USB supply so voltage and current can be controlled).
 
 		Access: Read, Write
+
 		Valid values:
+
+			== ==================================================
 			0: Offline
 			1: Online Fixed - Fixed Voltage Supply
 			2: Online Programmable - Programmable Voltage Supply
+			== ==================================================
 
 What:		/sys/class/power_supply/<supply_name>/temp
 Date:		May 2007
@@ -436,6 +473,7 @@ Description:
 		TJUNC temperature of an IC)
 
 		Access: Read
+
 		Valid values: Represented in 1/10 Degrees Celsius
 
 What:		/sys/class/power_supply/<supply_name>/temp_alert_max
@@ -451,6 +489,7 @@ Description:
 		remedy the situation).
 
 		Access: Read
+
 		Valid values: Represented in 1/10 Degrees Celsius
 
 What:		/sys/class/power_supply/<supply_name>/temp_alert_min
@@ -466,6 +505,7 @@ Description:
 		accordingly to remedy the situation).
 
 		Access: Read
+
 		Valid values: Represented in 1/10 Degrees Celsius
 
 What:		/sys/class/power_supply/<supply_name>/temp_max
@@ -475,6 +515,7 @@ Description:
 		Reports the maximum allowed supply temperature for operation.
 
 		Access: Read
+
 		Valid values: Represented in 1/10 Degrees Celsius
 
 What:		/sys/class/power_supply/<supply_name>/temp_min
@@ -484,6 +525,7 @@ Description:
 		Reports the mainimum allowed supply temperature for operation.
 
 		Access: Read
+
 		Valid values: Represented in 1/10 Degrees Celsius
 
 What: 		/sys/class/power_supply/<supply_name>/usb_type
@@ -495,7 +537,9 @@ Description:
 		is attached.
 
 		Access: Read-Only
-		Valid values: "Unknown", "SDP", "DCP", "CDP", "ACA", "C", "PD",
+
+		Valid values:
+			      "Unknown", "SDP", "DCP", "CDP", "ACA", "C", "PD",
 			      "PD_DRP", "PD_PPS", "BrickID"
 
 What: 		/sys/class/power_supply/<supply_name>/voltage_max
@@ -505,6 +549,7 @@ Description:
 		Reports the maximum VBUS voltage the supply can support.
 
 		Access: Read
+
 		Valid values: Represented in microvolts
 
 What: 		/sys/class/power_supply/<supply_name>/voltage_min
@@ -514,6 +559,7 @@ Description:
 		Reports the minimum VBUS voltage the supply can support.
 
 		Access: Read
+
 		Valid values: Represented in microvolts
 
 What: 		/sys/class/power_supply/<supply_name>/voltage_now
@@ -526,9 +572,10 @@ Description:
 		within the reported min/max range.
 
 		Access: Read, Write
+
 		Valid values: Represented in microvolts
 
-===== Device Specific Properties =====
+**Device Specific Properties**
 
 What:		/sys/class/power/ds2760-battery.*/charge_now
 Date:		May 2010
@@ -562,6 +609,7 @@ Description:
 		will drop to 0 A) and will trigger interrupt.
 
 		Valid values:
+
 		- 5, 6 or 7 (hours),
 		- 0: disabled.
 
@@ -576,6 +624,7 @@ Description:
 		will drop to 0 A) and will trigger interrupt.
 
 		Valid values:
+
 		- 4 - 16 (hours), step by 2 (rounded down)
 		- 0: disabled.
 
@@ -590,6 +639,7 @@ Description:
 		interrupt and start top-off charging mode.
 
 		Valid values:
+
 		- 100000 - 200000 (microamps), step by 25000 (rounded down)
 		- 200000 - 350000 (microamps), step by 50000 (rounded down)
 		- 0: disabled.
@@ -605,6 +655,7 @@ Description:
 		will drop to 0 A) and will trigger interrupt.
 
 		Valid values:
+
 		- 0 - 70 (minutes), step by 10 (rounded down)
 
 What:		/sys/class/power_supply/bq24257-charger/ovp_voltage
@@ -618,6 +669,7 @@ Description:
 		device datasheet for details.
 
 		Valid values:
+
 		- 6000000, 6500000, 7000000, 8000000, 9000000, 9500000, 10000000,
 		  10500000 (all uV)
 
@@ -633,6 +685,7 @@ Description:
 		lower than the set value. See device datasheet for details.
 
 		Valid values:
+
 		- 4200000, 4280000, 4360000, 4440000, 4520000, 4600000, 4680000,
 		  4760000 (all uV)
 
@@ -647,6 +700,7 @@ Description:
 		the charger operates normally. See device datasheet for details.
 
 		Valid values:
+
 		- 1: enabled
 		- 0: disabled
 
@@ -662,5 +716,6 @@ Description:
 		from the system. See device datasheet for details.
 
 		Valid values:
+
 		- 1: enabled
 		- 0: disabled
diff --git a/Documentation/ABI/testing/sysfs-class-power-twl4030 b/Documentation/ABI/testing/sysfs-class-power-twl4030
index b4fd32d210c5..7ac36dba87bc 100644
--- a/Documentation/ABI/testing/sysfs-class-power-twl4030
+++ b/Documentation/ABI/testing/sysfs-class-power-twl4030
@@ -4,18 +4,20 @@ Description:
 	Writing to this can disable charging.
 
 	Possible values are:
-		"auto" - draw power as appropriate for detected
-			 power source and battery status.
-		"off"  - do not draw any power.
-		"continuous"
-		       - activate mode described as "linear" in
-		         TWL data sheets.  This uses whatever
-			 current is available and doesn't switch off
-			 when voltage drops.
 
-			 This is useful for unstable power sources
-			 such as bicycle dynamo, but care should
-			 be taken that battery is not over-charged.
+		=============	===========================================
+		"auto" 		draw power as appropriate for detected
+				power source and battery status.
+		"off"  		do not draw any power.
+		"continuous"	activate mode described as "linear" in
+				TWL data sheets.  This uses whatever
+				current is available and doesn't switch off
+				when voltage drops.
+
+				This is useful for unstable power sources
+				such as bicycle dynamo, but care should
+				be taken that battery is not over-charged.
+		=============	===========================================
 
 What: /sys/class/power_supply/twl4030_ac/mode
 Description:
@@ -23,6 +25,9 @@ Description:
 	Writing to this can disable charging.
 
 	Possible values are:
-		"auto" - draw power as appropriate for detected
-			 power source and battery status.
-		"off"  - do not draw any power.
+
+		======	===========================================
+		"auto"	draw power as appropriate for detected
+			power source and battery status.
+		"off"	do not draw any power.
+		======	===========================================
diff --git a/Documentation/ABI/testing/sysfs-class-rc b/Documentation/ABI/testing/sysfs-class-rc
index 6c0d6c8cb911..9c8ff7910858 100644
--- a/Documentation/ABI/testing/sysfs-class-rc
+++ b/Documentation/ABI/testing/sysfs-class-rc
@@ -21,15 +21,22 @@ KernelVersion:	2.6.36
 Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Reading this file returns a list of available protocols,
-		something like:
+		something like::
+
 		    "rc5 [rc6] nec jvc [sony]"
+
 		Enabled protocols are shown in [] brackets.
+
 		Writing "+proto" will add a protocol to the list of enabled
 		protocols.
+
 		Writing "-proto" will remove a protocol from the list of enabled
 		protocols.
+
 		Writing "proto" will enable only "proto".
+
 		Writing "none" will disable all protocols.
+
 		Write fails with EINVAL if an invalid protocol combination or
 		unknown protocol name is used.
 
@@ -39,11 +46,13 @@ KernelVersion:	3.15
 Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Sets the scancode filter expected value.
+
 		Use in combination with /sys/class/rc/rcN/filter_mask to set the
 		expected value of the bits set in the filter mask.
 		If the hardware supports it then scancodes which do not match
 		the filter will be ignored. Otherwise the write will fail with
 		an error.
+
 		This value may be reset to 0 if the current protocol is altered.
 
 What:		/sys/class/rc/rcN/filter_mask
@@ -56,9 +65,11 @@ Description:
 		of the scancode which should be compared against the expected
 		value. A value of 0 disables the filter to allow all valid
 		scancodes to be processed.
+
 		If the hardware supports it then scancodes which do not match
 		the filter will be ignored. Otherwise the write will fail with
 		an error.
+
 		This value may be reset to 0 if the current protocol is altered.
 
 What:		/sys/class/rc/rcN/wakeup_protocols
@@ -67,15 +78,22 @@ KernelVersion:	4.11
 Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Reading this file returns a list of available protocols to use
-		for the wakeup filter, something like:
+		for the wakeup filter, something like::
+
 		    "rc-5 nec nec-x rc-6-0 rc-6-6a-24 [rc-6-6a-32] rc-6-mce"
+
 		Note that protocol variants are listed, so "nec", "sony",
 		"rc-5", "rc-6" have their different bit length encodings
 		listed if available.
+
 		The enabled wakeup protocol is shown in [] brackets.
+
 		Only one protocol can be selected at a time.
+
 		Writing "proto" will use "proto" for wakeup events.
+
 		Writing "none" will disable wakeup.
+
 		Write fails with EINVAL if an invalid protocol combination or
 		unknown protocol name is used, or if wakeup is not supported by
 		the hardware.
@@ -86,13 +104,17 @@ KernelVersion:	3.15
 Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Sets the scancode wakeup filter expected value.
+
 		Use in combination with /sys/class/rc/rcN/wakeup_filter_mask to
 		set the expected value of the bits set in the wakeup filter mask
 		to trigger a system wake event.
+
 		If the hardware supports it and wakeup_filter_mask is not 0 then
 		scancodes which match the filter will wake the system from e.g.
 		suspend to RAM or power off.
+
 		Otherwise the write will fail with an error.
+
 		This value may be reset to 0 if the wakeup protocol is altered.
 
 What:		/sys/class/rc/rcN/wakeup_filter_mask
@@ -101,11 +123,15 @@ KernelVersion:	3.15
 Contact:	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 Description:
 		Sets the scancode wakeup filter mask of bits to compare.
+
 		Use in combination with /sys/class/rc/rcN/wakeup_filter to set
 		the bits of the scancode which should be compared against the
 		expected value to trigger a system wake event.
+
 		If the hardware supports it and wakeup_filter_mask is not 0 then
 		scancodes which match the filter will wake the system from e.g.
 		suspend to RAM or power off.
+
 		Otherwise the write will fail with an error.
+
 		This value may be reset to 0 if the wakeup protocol is altered.
diff --git a/Documentation/ABI/testing/sysfs-class-scsi_host b/Documentation/ABI/testing/sysfs-class-scsi_host
index bafc59fd7b69..7c98d8f43c45 100644
--- a/Documentation/ABI/testing/sysfs-class-scsi_host
+++ b/Documentation/ABI/testing/sysfs-class-scsi_host
@@ -56,8 +56,9 @@ Description:
 		management) on top, which makes it match the Windows IRST (Intel
 		Rapid Storage Technology) driver settings. This setting is also
 		close to min_power, except that:
+
 		a) It does not use host-initiated slumber mode, but it does
-		allow device-initiated slumber
+		   allow device-initiated slumber
 		b) It does not enable low power device sleep mode (DevSlp).
 
 What:		/sys/class/scsi_host/hostX/em_message
@@ -70,8 +71,8 @@ Description:
 		protocol, writes and reads correspond to the LED message format
 		as defined in the AHCI spec.
 
-		The user must turn sw_activity (under /sys/block/*/device/) OFF
-		it they wish to control the activity LED via the em_message
+		The user must turn sw_activity (under `/sys/block/*/device/`)
+		OFF it they wish to control the activity LED via the em_message
 		file.
 
 		em_message_type: (RO) Displays the current enclosure management
diff --git a/Documentation/ABI/testing/sysfs-class-typec b/Documentation/ABI/testing/sysfs-class-typec
index d7647b258c3c..56fb854718ee 100644
--- a/Documentation/ABI/testing/sysfs-class-typec
+++ b/Documentation/ABI/testing/sysfs-class-typec
@@ -40,10 +40,13 @@ Description:
 		attribute will not return until the operation has finished.
 
 		Valid values:
-		- source (The port will behave as source only DFP port)
-		- sink (The port will behave as sink only UFP port)
-		- dual (The port will behave as dual-role-data and
+
+		======  ==============================================
+		source  (The port will behave as source only DFP port)
+		sink    (The port will behave as sink only UFP port)
+		dual    (The port will behave as dual-role-data and
 			dual-role-power port)
+		======  ==============================================
 
 What:		/sys/class/typec/<port>/vconn_source
 Date:		April 2017
@@ -59,6 +62,7 @@ Description:
 		generates uevent KOBJ_CHANGE.
 
 		Valid values:
+
 		- "no" when the port is not the VCONN Source
 		- "yes" when the port is the VCONN Source
 
@@ -72,6 +76,7 @@ Description:
 		power operation mode should show "usb_power_delivery".
 
 		Valid values:
+
 		- default
 		- 1.5A
 		- 3.0A
@@ -182,6 +187,7 @@ Date:		April 2017
 Contact:	Heikki Krogerus <heikki.krogerus@linux.intel.com>
 Description:
 		Shows type of the plug on the cable:
+
 		- type-a - Standard A
 		- type-b - Standard B
 		- type-c
diff --git a/Documentation/ABI/testing/sysfs-devices-platform-ACPI-TAD b/Documentation/ABI/testing/sysfs-devices-platform-ACPI-TAD
index 7e43cdce9a52..f7b360a61b21 100644
--- a/Documentation/ABI/testing/sysfs-devices-platform-ACPI-TAD
+++ b/Documentation/ABI/testing/sysfs-devices-platform-ACPI-TAD
@@ -7,6 +7,7 @@ Description:
 		(RO) Hexadecimal bitmask of the TAD attributes are reported by
 		the platform firmware (see ACPI 6.2, section 9.18.2):
 
+		======= ======================================================
 		BIT(0): AC wakeup implemented if set
 		BIT(1): DC wakeup implemented if set
 		BIT(2): Get/set real time features implemented if set
@@ -16,6 +17,7 @@ Description:
 		BIT(6): The AC timer wakes up from S5 if set
 		BIT(7): The DC timer wakes up from S4 if set
 		BIT(8): The DC timer wakes up from S5 if set
+		======= ======================================================
 
 		The other bits are reserved.
 
@@ -62,9 +64,11 @@ Description:
 		timer status with the following meaning of bits (see ACPI 6.2,
 		Section 9.18.5):
 
+		======= ======================================================
 		Bit(0): The timer has expired if set.
 		Bit(1): The timer has woken up the system from a sleep state
 		        (S3 or S4/S5 if supported) if set.
+		======= ======================================================
 
 		The other bits are reserved.
 
diff --git a/Documentation/ABI/testing/sysfs-devices-platform-docg3 b/Documentation/ABI/testing/sysfs-devices-platform-docg3
index 8aa36716882f..378c42694bfb 100644
--- a/Documentation/ABI/testing/sysfs-devices-platform-docg3
+++ b/Documentation/ABI/testing/sysfs-devices-platform-docg3
@@ -9,8 +9,10 @@ Description:
 		The protection has information embedded whether it blocks reads,
 		writes or both.
 		The result is:
-		0 -> the DPS is not keylocked
-		1 -> the DPS is keylocked
+
+		- 0 -> the DPS is not keylocked
+		- 1 -> the DPS is keylocked
+
 Users:		None identified so far.
 
 What:		/sys/devices/platform/docg3/f[0-3]_dps[01]_protection_key
@@ -27,8 +29,12 @@ Description:
 		Entering the correct value toggle the lock, and can be observed
 		through f[0-3]_dps[01]_is_keylocked.
 		Possible values are:
+
 			- 8 bytes
+
 		Typical values are:
+
 			- "00000000"
 			- "12345678"
+
 Users:		None identified so far.
diff --git a/Documentation/ABI/testing/sysfs-devices-platform-sh_mobile_lcdc_fb b/Documentation/ABI/testing/sysfs-devices-platform-sh_mobile_lcdc_fb
index 2107082426da..e45ac2e865d5 100644
--- a/Documentation/ABI/testing/sysfs-devices-platform-sh_mobile_lcdc_fb
+++ b/Documentation/ABI/testing/sysfs-devices-platform-sh_mobile_lcdc_fb
@@ -17,10 +17,10 @@ Description:
 		to overlay planes.
 
 		Selects the composition mode for the overlay. Possible values
-		are
+		are:
 
-		0 - Alpha Blending
-		1 - ROP3
+		- 0 - Alpha Blending
+		- 1 - ROP3
 
 What:		/sys/devices/platform/sh_mobile_lcdc_fb.[0-3]/graphics/fb[0-9]/ovl_position
 Date:		May 2012
@@ -30,7 +30,7 @@ Description:
 		to overlay planes.
 
 		Stores the x,y overlay position on the display in pixels. The
-		position format is `[0-9]+,[0-9]+'.
+		position format is `[0-9]+,[0-9]+`.
 
 What:		/sys/devices/platform/sh_mobile_lcdc_fb.[0-3]/graphics/fb[0-9]/ovl_rop3
 Date:		May 2012
diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 5f7d7b14fa44..ded63ae944df 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -157,23 +157,28 @@ Description:
 		The processor idle states which are available for use have the
 		following attributes:
 
-		name: (RO) Name of the idle state (string).
+		======== ==== =================================================
+		name:	 (RO) Name of the idle state (string).
 
 		latency: (RO) The latency to exit out of this idle state (in
-		microseconds).
+			      microseconds).
 
-		power: (RO) The power consumed while in this idle state (in
-		milliwatts).
+		power:   (RO) The power consumed while in this idle state (in
+			      milliwatts).
 
-		time: (RO) The total time spent in this idle state (in microseconds).
+		time:    (RO) The total time spent in this idle state
+			      (in microseconds).
 
-		usage: (RO) Number of times this state was entered (a count).
+		usage:	 (RO) Number of times this state was entered (a count).
 
-		above: (RO) Number of times this state was entered, but the
-		       observed CPU idle duration was too short for it (a count).
+		above:	 (RO) Number of times this state was entered, but the
+			      observed CPU idle duration was too short for it
+			      (a count).
 
-		below: (RO) Number of times this state was entered, but the
-		       observed CPU idle duration was too long for it (a count).
+		below: 	 (RO) Number of times this state was entered, but the
+			      observed CPU idle duration was too long for it
+			      (a count).
+		======== ==== =================================================
 
 What:		/sys/devices/system/cpu/cpuX/cpuidle/stateN/desc
 Date:		February 2008
@@ -290,6 +295,7 @@ Description:	Processor frequency boosting control
 		This switch controls the boost setting for the whole system.
 		Boosting allows the CPU and the firmware to run at a frequency
 		beyound it's nominal limit.
+
 		More details can be found in
 		Documentation/admin-guide/pm/cpufreq.rst
 
@@ -337,43 +343,57 @@ Contact:	Sudeep Holla <sudeep.holla@arm.com>
 Description:	Parameters for the CPU cache attributes
 
 		allocation_policy:
-			- WriteAllocate: allocate a memory location to a cache line
-					 on a cache miss because of a write
-			- ReadAllocate: allocate a memory location to a cache line
+			- WriteAllocate:
+					allocate a memory location to a cache line
+					on a cache miss because of a write
+			- ReadAllocate:
+					allocate a memory location to a cache line
 					on a cache miss because of a read
-			- ReadWriteAllocate: both writeallocate and readallocate
+			- ReadWriteAllocate:
+					both writeallocate and readallocate
 
-		attributes: LEGACY used only on IA64 and is same as write_policy
+		attributes:
+			    LEGACY used only on IA64 and is same as write_policy
 
-		coherency_line_size: the minimum amount of data in bytes that gets
+		coherency_line_size:
+				     the minimum amount of data in bytes that gets
 				     transferred from memory to cache
 
-		level: the cache hierarchy in the multi-level cache configuration
+		level:
+			the cache hierarchy in the multi-level cache configuration
 
-		number_of_sets: total number of sets in the cache, a set is a
+		number_of_sets:
+				total number of sets in the cache, a set is a
 				collection of cache lines with the same cache index
 
-		physical_line_partition: number of physical cache line per cache tag
+		physical_line_partition:
+				number of physical cache line per cache tag
 
-		shared_cpu_list: the list of logical cpus sharing the cache
+		shared_cpu_list:
+				the list of logical cpus sharing the cache
 
-		shared_cpu_map: logical cpu mask containing the list of cpus sharing
+		shared_cpu_map:
+				logical cpu mask containing the list of cpus sharing
 				the cache
 
-		size: the total cache size in kB
+		size:
+			the total cache size in kB
 
 		type:
 			- Instruction: cache that only holds instructions
 			- Data: cache that only caches data
 			- Unified: cache that holds both data and instructions
 
-		ways_of_associativity: degree of freedom in placing a particular block
-					of memory in the cache
+		ways_of_associativity:
+			degree of freedom in placing a particular block
+			of memory in the cache
 
 		write_policy:
-			- WriteThrough: data is written to both the cache line
+			- WriteThrough:
+					data is written to both the cache line
 					and to the block in the lower-level memory
-			- WriteBack: data is written only to the cache line and
+			- WriteBack:
+				     data is written only to the cache line and
 				     the modified cache line is written to main
 				     memory only when it is replaced
 
@@ -414,30 +434,30 @@ Description:	POWERNV CPUFreq driver's frequency throttle stats directory and
 		throttle attributes exported in the 'throttle_stats' directory:
 
 		- turbo_stat : This file gives the total number of times the max
-		frequency is throttled to lower frequency in turbo (at and above
-		nominal frequency) range of frequencies.
+		  frequency is throttled to lower frequency in turbo (at and above
+		  nominal frequency) range of frequencies.
 
 		- sub_turbo_stat : This file gives the total number of times the
-		max frequency is throttled to lower frequency in sub-turbo(below
-		nominal frequency) range of frequencies.
+		  max frequency is throttled to lower frequency in sub-turbo(below
+		  nominal frequency) range of frequencies.
 
 		- unthrottle : This file gives the total number of times the max
-		frequency is unthrottled after being throttled.
+		  frequency is unthrottled after being throttled.
 
 		- powercap : This file gives the total number of times the max
-		frequency is throttled due to 'Power Capping'.
+		  frequency is throttled due to 'Power Capping'.
 
 		- overtemp : This file gives the total number of times the max
-		frequency is throttled due to 'CPU Over Temperature'.
+		  frequency is throttled due to 'CPU Over Temperature'.
 
 		- supply_fault : This file gives the total number of times the
-		max frequency is throttled due to 'Power Supply Failure'.
+		  max frequency is throttled due to 'Power Supply Failure'.
 
 		- overcurrent : This file gives the total number of times the
-		max frequency is throttled due to 'Overcurrent'.
+		  max frequency is throttled due to 'Overcurrent'.
 
 		- occ_reset : This file gives the total number of times the max
-		frequency is throttled due to 'OCC Reset'.
+		  frequency is throttled due to 'OCC Reset'.
 
 		The sysfs attributes representing different throttle reasons like
 		powercap, overtemp, supply_fault, overcurrent and occ_reset map to
@@ -469,8 +489,9 @@ What:		/sys/devices/system/cpu/cpuX/regs/
 Date:		June 2016
 Contact:	Linux ARM Kernel Mailing list <linux-arm-kernel@lists.infradead.org>
 Description:	AArch64 CPU registers
+
 		'identification' directory exposes the CPU ID registers for
-		 identifying model and revision of the CPU.
+		identifying model and revision of the CPU.
 
 What:		/sys/devices/system/cpu/cpu#/cpu_capacity
 Date:		December 2016
@@ -494,9 +515,11 @@ Description:	Information about CPU vulnerabilities
 		vulnerabilities. The output of those files reflects the
 		state of the CPUs in the system. Possible output values:
 
+		================  ==============================================
 		"Not affected"	  CPU is not affected by the vulnerability
 		"Vulnerable"	  CPU is affected and no mitigation in effect
 		"Mitigation: $M"  CPU is affected and mitigation $M is in effect
+		================  ==============================================
 
 		See also: Documentation/admin-guide/hw-vuln/index.rst
 
@@ -512,12 +535,14 @@ Description:	Control Symetric Multi Threading (SMT)
 		control: Read/write interface to control SMT. Possible
 			 values:
 
+			 ================ =========================================
 			 "on"		  SMT is enabled
 			 "off"		  SMT is disabled
 			 "forceoff"	  SMT is force disabled. Cannot be changed.
 			 "notsupported"   SMT is not supported by the CPU
 			 "notimplemented" SMT runtime toggling is not
 					  implemented for the architecture
+			 ================ =========================================
 
 			 If control status is "forceoff" or "notsupported" writes
 			 are rejected.
diff --git a/Documentation/ABI/testing/sysfs-devices-system-ibm-rtl b/Documentation/ABI/testing/sysfs-devices-system-ibm-rtl
index 470def06ab0a..1a8ee26e92ae 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-ibm-rtl
+++ b/Documentation/ABI/testing/sysfs-devices-system-ibm-rtl
@@ -5,8 +5,10 @@ Contact:        Vernon Mauery <vernux@us.ibm.com>
 Description:    The state file allows a means by which to change in and
                 out of Premium Real-Time Mode (PRTM), as well as the
                 ability to query the current state.
-                    0 => PRTM off
-                    1 => PRTM enabled
+
+                    - 0 => PRTM off
+                    - 1 => PRTM enabled
+
 Users:          The ibm-prtm userspace daemon uses this interface.
 
 
diff --git a/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator b/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator
index 4d63a7904b94..42214b4ff14a 100644
--- a/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator
+++ b/Documentation/ABI/testing/sysfs-driver-bd9571mwv-regulator
@@ -6,11 +6,13 @@ Description:	Read/write the current state of DDR Backup Mode, which controls
 		if DDR power rails will be kept powered during system suspend.
 		("on"/"1" = enabled, "off"/"0" = disabled).
 		Two types of power switches (or control signals) can be used:
+
 		  A. With a momentary power switch (or pulse signal), DDR
 		     Backup Mode is enabled by default when available, as the
 		     PMIC will be configured only during system suspend.
 		  B. With a toggle power switch (or level signal), the
 		     following steps must be followed exactly:
+
 		       1. Configure PMIC for backup mode, to change the role of
 			  the accessory power switch from a power switch to a
 			  wake-up switch,
@@ -20,8 +22,10 @@ Description:	Read/write the current state of DDR Backup Mode, which controls
 		       3. Suspend system,
 		       4. Switch accessory power switch on, to resume the
 			  system.
+
 		     DDR Backup Mode must be explicitly enabled by the user,
 		     to invoke step 1.
+
 		See also Documentation/devicetree/bindings/mfd/bd9571mwv.txt.
 Users:		User space applications for embedded boards equipped with a
 		BD9571MWV PMIC.
diff --git a/Documentation/ABI/testing/sysfs-driver-genwqe b/Documentation/ABI/testing/sysfs-driver-genwqe
index 64ac6d567c4b..69d855dc4c47 100644
--- a/Documentation/ABI/testing/sysfs-driver-genwqe
+++ b/Documentation/ABI/testing/sysfs-driver-genwqe
@@ -29,8 +29,12 @@ What:           /sys/class/genwqe/genwqe<n>_card/reload_bitstream
 Date:           May 2014
 Contact:        klebers@linux.vnet.ibm.com
 Description:    Interface to trigger a PCIe card reset to reload the bitstream.
+
+		::
+
                   sudo sh -c 'echo 1 > \
                     /sys/class/genwqe/genwqe0_card/reload_bitstream'
+
                 If successfully, the card will come back with the bitstream set
                 on 'next_bitstream'.
 
@@ -64,8 +68,11 @@ Description:    Base clock frequency of the card.
 What:           /sys/class/genwqe/genwqe<n>_card/device/sriov_numvfs
 Date:           Oct 2013
 Contact:        haver@linux.vnet.ibm.com
-Description:    Enable VFs (1..15):
+Description:    Enable VFs (1..15)::
+
                   sudo sh -c 'echo 15 > \
                     /sys/bus/pci/devices/0000\:1b\:00.0/sriov_numvfs'
-                Disable VFs:
+
+                Disable VFs::
+
                   Write a 0 into the same sysfs entry.
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-logitech-lg4ff b/Documentation/ABI/testing/sysfs-driver-hid-logitech-lg4ff
index 305dffd229a8..de07be314efc 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-logitech-lg4ff
+++ b/Documentation/ABI/testing/sysfs-driver-hid-logitech-lg4ff
@@ -12,7 +12,9 @@ KernelVersion:	4.1
 Contact:	Michal Malý <madcatxster@devoid-pointer.net>
 Description:	Displays a set of alternate modes supported by a wheel. Each
 		mode is listed as follows:
+
 		  Tag: Mode Name
+
 		Currently active mode is marked with an asterisk. List also
 		contains an abstract item "native" which always denotes the
 		native mode of the wheel. Echoing the mode tag switches the
@@ -24,24 +26,30 @@ Description:	Displays a set of alternate modes supported by a wheel. Each
 		This entry is not created for devices that have only one mode.
 
 		Currently supported mode switches:
-		Driving Force Pro:
+
+		Driving Force Pro::
+
 		  DF-EX --> DFP
 
-		G25:
+		G25::
+
 		  DF-EX --> DFP --> G25
 
-		G27:
+		G27::
+
 		  DF-EX <*> DFP <-> G25 <-> G27
 		  DF-EX <*--------> G25 <-> G27
 		  DF-EX <*----------------> G27
 
-		G29:
+		G29::
+
 		  DF-EX <*> DFP <-> G25 <-> G27 <-> G29
 		  DF-EX <*--------> G25 <-> G27 <-> G29
 		  DF-EX <*----------------> G27 <-> G29
 		  DF-EX <*------------------------> G29
 
-		DFGT:
+		DFGT::
+
 		  DF-EX <*> DFP <-> DFGT
 		  DF-EX <*--------> DFGT
 
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-wiimote b/Documentation/ABI/testing/sysfs-driver-hid-wiimote
index 39dfa5cb1cc5..cd7b82a5c27d 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-wiimote
+++ b/Documentation/ABI/testing/sysfs-driver-hid-wiimote
@@ -39,9 +39,13 @@ Description:	While a device is initialized by the wiimote driver, we perform
 		Other strings for each device-type are available and may be
 		added if new device-specific detections are added.
 		Currently supported are:
-			gen10: First Wii Remote generation
-			gen20: Second Wii Remote Plus generation (builtin MP)
+
+			============= =======================================
+			gen10:        First Wii Remote generation
+			gen20:        Second Wii Remote Plus generation
+				      (builtin MP)
 			balanceboard: Wii Balance Board
+			============= =======================================
 
 What:		/sys/bus/hid/drivers/wiimote/<dev>/bboard_calib
 Date:		May 2013
@@ -54,6 +58,7 @@ Description:	This attribute is only provided if the device was detected as a
 		First, 0kg values for all 4 sensors are written, followed by the
 		17kg values for all 4 sensors and last the 34kg values for all 4
 		sensors.
+
 		Calibration data is already applied by the kernel to all input
 		values but may be used by user-space to perform other
 		transformations.
@@ -68,9 +73,11 @@ Description:	This attribute is only provided if the device was detected as a
 		is prefixed with a +/-. Each value is a signed 16bit number.
 		Data is encoded as decimal numbers and specifies the offsets of
 		the analog sticks of the pro-controller.
+
 		Calibration data is already applied by the kernel to all input
 		values but may be used by user-space to perform other
 		transformations.
+
 		Calibration data is detected by the kernel during device setup.
 		You can write "scan\n" into this file to re-trigger calibration.
 		You can also write data directly in the form "x1:y1 x2:y2" to
diff --git a/Documentation/ABI/testing/sysfs-driver-samsung-laptop b/Documentation/ABI/testing/sysfs-driver-samsung-laptop
index 34d3a3359cf4..28c9c040de5d 100644
--- a/Documentation/ABI/testing/sysfs-driver-samsung-laptop
+++ b/Documentation/ABI/testing/sysfs-driver-samsung-laptop
@@ -9,10 +9,12 @@ Description:	Some Samsung laptops have different "performance levels"
 		their fans quiet at all costs.  Reading from this file
 		will show the current performance level.  Writing to the
 		file can change this value.
+
 			Valid options:
-				"silent"
-				"normal"
-				"overclock"
+				- "silent"
+				- "normal"
+				- "overclock"
+
 		Note that not all laptops support all of these options.
 		Specifically, not all support the "overclock" option,
 		and it's still unknown if this value even changes
@@ -25,8 +27,9 @@ Contact:	Corentin Chary <corentin.chary@gmail.com>
 Description:	Max battery charge level can be modified, battery cycle
 		life can be extended by reducing the max battery charge
 		level.
-		0 means normal battery mode (100% charge)
-		1 means battery life extender mode (80% charge)
+
+		- 0 means normal battery mode (100% charge)
+		- 1 means battery life extender mode (80% charge)
 
 What:		/sys/devices/platform/samsung/usb_charge
 Date:		December 1, 2011
diff --git a/Documentation/ABI/testing/sysfs-driver-toshiba_acpi b/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
index f34221b52b14..e5a438d84e1f 100644
--- a/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
+++ b/Documentation/ABI/testing/sysfs-driver-toshiba_acpi
@@ -4,10 +4,12 @@ KernelVersion:	3.15
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the keyboard backlight operation mode, valid
 		values are:
+
 			* 0x1  -> FN-Z
 			* 0x2  -> AUTO (also called TIMER)
 			* 0x8  -> ON
 			* 0x10 -> OFF
+
 		Note that from kernel 3.16 onwards this file accepts all listed
 		parameters, kernel 3.15 only accepts the first two (FN-Z and
 		AUTO).
@@ -41,8 +43,10 @@ KernelVersion:	3.15
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This files controls the status of the touchpad and pointing
 		stick (if available), valid values are:
+
 			* 0 -> OFF
 			* 1 -> ON
+
 Users:		KToshiba
 
 What:		/sys/devices/LNXSYSTM:00/LNXSYBUS:00/TOS{1900,620{0,7,8}}:00/available_kbd_modes
@@ -51,10 +55,12 @@ KernelVersion:	3.16
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file shows the supported keyboard backlight modes
 		the system supports, which can be:
+
 			* 0x1  -> FN-Z
 			* 0x2  -> AUTO (also called TIMER)
 			* 0x8  -> ON
 			* 0x10 -> OFF
+
 		Note that not all keyboard types support the listed modes.
 		See the entry named "available_kbd_modes"
 Users:		KToshiba
@@ -65,6 +71,7 @@ KernelVersion:	3.16
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file shows the current keyboard backlight type,
 		which can be:
+
 			* 1 -> Type 1, supporting modes FN-Z and AUTO
 			* 2 -> Type 2, supporting modes TIMER, ON and OFF
 Users:		KToshiba
@@ -75,10 +82,12 @@ KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the USB Sleep & Charge charging mode, which
 		can be:
+
 			* 0 -> Disabled		(0x00)
 			* 1 -> Alternate	(0x09)
 			* 2 -> Auto		(0x21)
 			* 3 -> Typical		(0x11)
+
 		Note that from kernel 4.1 onwards this file accepts all listed
 		values, kernel 4.0 only supports the first three.
 		Note that this feature only works when connected to power, if
@@ -93,8 +102,10 @@ Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the USB Sleep Functions under battery, and
 		set the level at which point they will be disabled, accepted
 		values can be:
+
 			* 0	-> Disabled
 			* 1-100	-> Battery level to disable sleep functions
+
 		Currently it prints two values, the first one indicates if the
 		feature is enabled or disabled, while the second one shows the
 		current battery level set.
@@ -107,8 +118,10 @@ Date:		January 23, 2015
 KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the USB Rapid Charge state, which can be:
+
 			* 0 -> Disabled
 			* 1 -> Enabled
+
 		Note that toggling this value requires a reboot for changes to
 		take effect.
 Users:		KToshiba
@@ -118,8 +131,10 @@ Date:		January 23, 2015
 KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the Sleep & Music state, which values can be:
+
 			* 0 -> Disabled
 			* 1 -> Enabled
+
 		Note that this feature only works when connected to power, if
 		you want to use it under battery, see the entry named
 		"sleep_functions_on_battery"
@@ -138,6 +153,7 @@ KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the state of the internal fan, valid
 		values are:
+
 			* 0 -> OFF
 			* 1 -> ON
 
@@ -147,8 +163,10 @@ KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the Special Functions (hotkeys) operation
 		mode, valid values are:
+
 			* 0 -> Normal Operation
 			* 1 -> Special Functions
+
 		In the "Normal Operation" mode, the F{1-12} keys are as usual
 		and the hotkeys are accessed via FN-F{1-12}.
 		In the "Special Functions" mode, the F{1-12} keys trigger the
@@ -163,8 +181,10 @@ KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls whether the laptop should turn ON whenever
 		the LID is opened, valid values are:
+
 			* 0 -> Disabled
 			* 1 -> Enabled
+
 		Note that toggling this value requires a reboot for changes to
 		take effect.
 Users:		KToshiba
@@ -174,8 +194,10 @@ Date:		February 12, 2015
 KernelVersion:	4.0
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the USB 3 functionality, valid values are:
+
 			* 0 -> Disabled (Acts as a regular USB 2)
 			* 1 -> Enabled (Full USB 3 functionality)
+
 		Note that toggling this value requires a reboot for changes to
 		take effect.
 Users:		KToshiba
@@ -188,10 +210,14 @@ Description:	This file controls the Cooling Method feature.
 		Reading this file prints two values, the first is the actual cooling method
 		and the second is the maximum cooling method supported.
 		When the maximum cooling method is ONE, valid values are:
+
 			* 0 -> Maximum Performance
 			* 1 -> Battery Optimized
+
 		When the maximum cooling method is TWO, valid values are:
+
 			* 0 -> Maximum Performance
 			* 1 -> Performance
 			* 2 -> Battery Optimized
+
 Users:		KToshiba
diff --git a/Documentation/ABI/testing/sysfs-driver-toshiba_haps b/Documentation/ABI/testing/sysfs-driver-toshiba_haps
index a662370b4dbf..c938690ce10d 100644
--- a/Documentation/ABI/testing/sysfs-driver-toshiba_haps
+++ b/Documentation/ABI/testing/sysfs-driver-toshiba_haps
@@ -4,10 +4,12 @@ KernelVersion:	3.17
 Contact:	Azael Avalos <coproscefalo@gmail.com>
 Description:	This file controls the built-in accelerometer protection level,
 		valid values are:
+
 			* 0 -> Disabled
 			* 1 -> Low
 			* 2 -> Medium
 			* 3 -> High
+
 		The default potection value is set to 2 (Medium).
 Users:		KToshiba
 
diff --git a/Documentation/ABI/testing/sysfs-driver-wacom b/Documentation/ABI/testing/sysfs-driver-wacom
index afc48fc163b5..16acaa5712ec 100644
--- a/Documentation/ABI/testing/sysfs-driver-wacom
+++ b/Documentation/ABI/testing/sysfs-driver-wacom
@@ -79,7 +79,9 @@ Description:
 		When the Wacom Intuos 4 is connected over Bluetooth, the
 		image has to contain 256 bytes (64x32 px 1 bit colour).
 		The format is also scrambled, like in the USB mode, and it can
-		be summarized by converting 76543210 into GECA6420.
+		be summarized by converting::
+
+					    76543210 into GECA6420.
 					    HGFEDCBA      HFDB7531
 
 What:		/sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_remote/unpair_remote
diff --git a/Documentation/ABI/testing/sysfs-firmware-acpi b/Documentation/ABI/testing/sysfs-firmware-acpi
index 613f42a9d5cd..e4afc2538210 100644
--- a/Documentation/ABI/testing/sysfs-firmware-acpi
+++ b/Documentation/ABI/testing/sysfs-firmware-acpi
@@ -12,11 +12,14 @@ Description:
 		image: The image bitmap. Currently a 32-bit BMP.
 		status: 1 if the image is valid, 0 if firmware invalidated it.
 		type: 0 indicates image is in BMP format.
+
+		======== ===================================================
 		version: The version of the BGRT. Currently 1.
 		xoffset: The number of pixels between the left of the screen
 			 and the left edge of the image.
 		yoffset: The number of pixels between the top of the screen
 			 and the top edge of the image.
+		======== ===================================================
 
 What:		/sys/firmware/acpi/hotplug/
 Date:		February 2013
@@ -33,12 +36,14 @@ Description:
 		The following setting is available to user space for each
 		hotplug profile:
 
+		======== =======================================================
 		enabled: If set, the ACPI core will handle notifications of
-			hotplug events associated with the given class of
-			devices and will allow those devices to be ejected with
-			the help of the _EJ0 control method.  Unsetting it
-			effectively disables hotplug for the correspoinding
-			class of devices.
+			 hotplug events associated with the given class of
+			 devices and will allow those devices to be ejected with
+			 the help of the _EJ0 control method.  Unsetting it
+			 effectively disables hotplug for the correspoinding
+			 class of devices.
+		======== =======================================================
 
 		The value of the above attribute is an integer number: 1 (set)
 		or 0 (unset).  Attempts to write any other values to it will
@@ -71,86 +76,90 @@ Description:
 		To figure out where all the SCI's are coming from,
 		/sys/firmware/acpi/interrupts contains a file listing
 		every possible source, and the count of how many
-		times it has triggered.
-
-		$ cd /sys/firmware/acpi/interrupts
-		$ grep . *
-		error:	     0
-		ff_gbl_lock:	   0   enable
-		ff_pmtimer:	  0  invalid
-		ff_pwr_btn:	  0   enable
-		ff_rt_clk:	 2  disable
-		ff_slp_btn:	  0  invalid
-		gpe00:	     0	invalid
-		gpe01:	     0	 enable
-		gpe02:	   108	 enable
-		gpe03:	     0	invalid
-		gpe04:	     0	invalid
-		gpe05:	     0	invalid
-		gpe06:	     0	 enable
-		gpe07:	     0	 enable
-		gpe08:	     0	invalid
-		gpe09:	     0	invalid
-		gpe0A:	     0	invalid
-		gpe0B:	     0	invalid
-		gpe0C:	     0	invalid
-		gpe0D:	     0	invalid
-		gpe0E:	     0	invalid
-		gpe0F:	     0	invalid
-		gpe10:	     0	invalid
-		gpe11:	     0	invalid
-		gpe12:	     0	invalid
-		gpe13:	     0	invalid
-		gpe14:	     0	invalid
-		gpe15:	     0	invalid
-		gpe16:	     0	invalid
-		gpe17:	  1084	 enable
-		gpe18:	     0	 enable
-		gpe19:	     0	invalid
-		gpe1A:	     0	invalid
-		gpe1B:	     0	invalid
-		gpe1C:	     0	invalid
-		gpe1D:	     0	invalid
-		gpe1E:	     0	invalid
-		gpe1F:	     0	invalid
-		gpe_all:    1192
-		sci:	1194
-		sci_not:     0	
-
-		sci - The number of times the ACPI SCI
-		has been called and claimed an interrupt.
-
-		sci_not - The number of times the ACPI SCI
-		has been called and NOT claimed an interrupt.
-
-		gpe_all - count of SCI caused by GPEs.
-
-		gpeXX - count for individual GPE source
-
-		ff_gbl_lock - Global Lock
-
-		ff_pmtimer - PM Timer
-
-		ff_pwr_btn - Power Button
-
-		ff_rt_clk - Real Time Clock
-
-		ff_slp_btn - Sleep Button
-
-		error - an interrupt that can't be accounted for above.
-
-		invalid: it's either a GPE or a Fixed Event that
-			doesn't have an event handler.
-
-		disable: the GPE/Fixed Event is valid but disabled.
-
-		enable: the GPE/Fixed Event is valid and enabled.
-
-		Root has permission to clear any of these counters.  Eg.
-		# echo 0 > gpe11
-
-		All counters can be cleared by clearing the total "sci":
-		# echo 0 > sci
+		times it has triggered::
+
+		  $ cd /sys/firmware/acpi/interrupts
+		  $ grep . *
+		  error:	     0
+		  ff_gbl_lock:	   0   enable
+		  ff_pmtimer:	  0  invalid
+		  ff_pwr_btn:	  0   enable
+		  ff_rt_clk:	 2  disable
+		  ff_slp_btn:	  0  invalid
+		  gpe00:	     0	invalid
+		  gpe01:	     0	 enable
+		  gpe02:	   108	 enable
+		  gpe03:	     0	invalid
+		  gpe04:	     0	invalid
+		  gpe05:	     0	invalid
+		  gpe06:	     0	 enable
+		  gpe07:	     0	 enable
+		  gpe08:	     0	invalid
+		  gpe09:	     0	invalid
+		  gpe0A:	     0	invalid
+		  gpe0B:	     0	invalid
+		  gpe0C:	     0	invalid
+		  gpe0D:	     0	invalid
+		  gpe0E:	     0	invalid
+		  gpe0F:	     0	invalid
+		  gpe10:	     0	invalid
+		  gpe11:	     0	invalid
+		  gpe12:	     0	invalid
+		  gpe13:	     0	invalid
+		  gpe14:	     0	invalid
+		  gpe15:	     0	invalid
+		  gpe16:	     0	invalid
+		  gpe17:	  1084	 enable
+		  gpe18:	     0	 enable
+		  gpe19:	     0	invalid
+		  gpe1A:	     0	invalid
+		  gpe1B:	     0	invalid
+		  gpe1C:	     0	invalid
+		  gpe1D:	     0	invalid
+		  gpe1E:	     0	invalid
+		  gpe1F:	     0	invalid
+		  gpe_all:    1192
+		  sci:	1194
+		  sci_not:     0
+
+		===========  ==================================================
+		sci	     The number of times the ACPI SCI
+			     has been called and claimed an interrupt.
+
+		sci_not	     The number of times the ACPI SCI
+			     has been called and NOT claimed an interrupt.
+
+		gpe_all	     count of SCI caused by GPEs.
+
+		gpeXX	     count for individual GPE source
+
+		ff_gbl_lock  Global Lock
+
+		ff_pmtimer   PM Timer
+
+		ff_pwr_btn   Power Button
+
+		ff_rt_clk    Real Time Clock
+
+		ff_slp_btn   Sleep Button
+
+		error	     an interrupt that can't be accounted for above.
+
+		invalid      it's either a GPE or a Fixed Event that
+			     doesn't have an event handler.
+
+		disable	     the GPE/Fixed Event is valid but disabled.
+
+		enable       the GPE/Fixed Event is valid and enabled.
+		===========  ==================================================
+
+		Root has permission to clear any of these counters.  Eg.::
+
+		  # echo 0 > gpe11
+
+		All counters can be cleared by clearing the total "sci"::
+
+		  # echo 0 > sci
 
 		None of these counters has an effect on the function
 		of the system, they are simply statistics.
@@ -165,32 +174,34 @@ Description:
 
 		Let's take power button fixed event for example, please kill acpid
 		and other user space applications so that the machine won't shutdown
-		when pressing the power button.
-		# cat ff_pwr_btn
-		0	enabled
-		# press the power button for 3 times;
-		# cat ff_pwr_btn
-		3	enabled
-		# echo disable > ff_pwr_btn
-		# cat ff_pwr_btn
-		3	disabled
-		# press the power button for 3 times;
-		# cat ff_pwr_btn
-		3	disabled
-		# echo enable > ff_pwr_btn
-		# cat ff_pwr_btn
-		4	enabled
-		/*
-		 * this is because the status bit is set even if the enable bit is cleared,
-		 * and it triggers an ACPI fixed event when the enable bit is set again
-		 */
-		# press the power button for 3 times;
-		# cat ff_pwr_btn
-		7	enabled
-		# echo disable > ff_pwr_btn
-		# press the power button for 3 times;
-		# echo clear > ff_pwr_btn	/* clear the status bit */
-		# echo disable > ff_pwr_btn
-		# cat ff_pwr_btn
-		7	enabled
+		when pressing the power button::
+
+		  # cat ff_pwr_btn
+		  0	enabled
+		  # press the power button for 3 times;
+		  # cat ff_pwr_btn
+		  3	enabled
+		  # echo disable > ff_pwr_btn
+		  # cat ff_pwr_btn
+		  3	disabled
+		  # press the power button for 3 times;
+		  # cat ff_pwr_btn
+		  3	disabled
+		  # echo enable > ff_pwr_btn
+		  # cat ff_pwr_btn
+		  4	enabled
+		  /*
+		   * this is because the status bit is set even if the enable
+		   * bit is cleared, and it triggers an ACPI fixed event when
+		   * the enable bit is set again
+		   */
+		  # press the power button for 3 times;
+		  # cat ff_pwr_btn
+		  7	enabled
+		  # echo disable > ff_pwr_btn
+		  # press the power button for 3 times;
+		  # echo clear > ff_pwr_btn	/* clear the status bit */
+		  # echo disable > ff_pwr_btn
+		  # cat ff_pwr_btn
+		  7	enabled
 
diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi-entries b/Documentation/ABI/testing/sysfs-firmware-dmi-entries
index 210ad44b95a5..fe0289c87768 100644
--- a/Documentation/ABI/testing/sysfs-firmware-dmi-entries
+++ b/Documentation/ABI/testing/sysfs-firmware-dmi-entries
@@ -33,7 +33,7 @@ Description:
 		doesn't matter), they will be represented in sysfs as
 		entries "T-0" through "T-(N-1)":
 
-		Example entry directories:
+		Example entry directories::
 
 			/sys/firmware/dmi/entries/17-0
 			/sys/firmware/dmi/entries/17-1
@@ -50,61 +50,65 @@ Description:
 		Each DMI entry in sysfs has the common header values
 		exported as attributes:
 
-		handle	: The 16bit 'handle' that is assigned to this
+		========  =================================================
+		handle	  The 16bit 'handle' that is assigned to this
 			  entry by the firmware.  This handle may be
 			  referred to by other entries.
-		length	: The length of the entry, as presented in the
+		length	  The length of the entry, as presented in the
 			  entry itself.  Note that this is _not the
 			  total count of bytes associated with the
-			  entry_.  This value represents the length of
+			  entry.  This value represents the length of
 			  the "formatted" portion of the entry.  This
 			  "formatted" region is sometimes followed by
 			  the "unformatted" region composed of nul
 			  terminated strings, with termination signalled
 			  by a two nul characters in series.
-		raw	: The raw bytes of the entry. This includes the
+		raw	  The raw bytes of the entry. This includes the
 			  "formatted" portion of the entry, the
 			  "unformatted" strings portion of the entry,
 			  and the two terminating nul characters.
-		type	: The type of the entry.  This value is the same
+		type	  The type of the entry.  This value is the same
 			  as found in the directory name.  It indicates
 			  how the rest of the entry should be interpreted.
-		instance: The instance ordinal of the entry for the
+		instance  The instance ordinal of the entry for the
 			  given type.  This value is the same as found
 			  in the parent directory name.
-		position: The ordinal position (zero-based) of the entry
+		position  The ordinal position (zero-based) of the entry
 			  within the entirety of the DMI entry table.
+		========  =================================================
 
-		=== Entry Specialization ===
+		**Entry Specialization**
 
 		Some entry types may have other information available in
 		sysfs.  Not all types are specialized.
 
-		--- Type 15 - System Event Log ---
+		**Type 15 - System Event Log**
 
 		This entry allows the firmware to export a log of
 		events the system has taken.  This information is
 		typically backed by nvram, but the implementation
 		details are abstracted by this table.  This entry's data
-		is exported in the directory:
+		is exported in the directory::
 
-		/sys/firmware/dmi/entries/15-0/system_event_log
+		  /sys/firmware/dmi/entries/15-0/system_event_log
 
 		and has the following attributes (documented in the
 		SMBIOS / DMI specification under "System Event Log (Type 15)":
 
-		area_length
-		header_start_offset
-		data_start_offset
-		access_method
-		status
-		change_token
-		access_method_address
-		header_format
-		per_log_type_descriptor_length
-		type_descriptors_supported_count
+		- area_length
+		- header_start_offset
+		- data_start_offset
+		- access_method
+		- status
+		- change_token
+		- access_method_address
+		- header_format
+		- per_log_type_descriptor_length
+		- type_descriptors_supported_count
 
 		As well, the kernel exports the binary attribute:
 
-		raw_event_log	: The raw binary bits of the event log
+		=============	  ====================================
+		raw_event_log	  The raw binary bits of the event log
 				  as described by the DMI entry.
+		=============	  ====================================
diff --git a/Documentation/ABI/testing/sysfs-firmware-gsmi b/Documentation/ABI/testing/sysfs-firmware-gsmi
index 0faa0aaf4b6a..7a558354c1ee 100644
--- a/Documentation/ABI/testing/sysfs-firmware-gsmi
+++ b/Documentation/ABI/testing/sysfs-firmware-gsmi
@@ -20,7 +20,7 @@ Description:
 
 			This directory has the same layout (and
 			underlying implementation as /sys/firmware/efi/vars.
-			See Documentation/ABI/*/sysfs-firmware-efi-vars
+			See `Documentation/ABI/*/sysfs-firmware-efi-vars`
 			for more information on how to interact with
 			this structure.
 
diff --git a/Documentation/ABI/testing/sysfs-firmware-memmap b/Documentation/ABI/testing/sysfs-firmware-memmap
index eca0d65087dc..1f6f4d3a32c0 100644
--- a/Documentation/ABI/testing/sysfs-firmware-memmap
+++ b/Documentation/ABI/testing/sysfs-firmware-memmap
@@ -20,7 +20,7 @@ Description:
 		the raw memory map to userspace.
 
 		The structure is as follows: Under /sys/firmware/memmap there
-		are subdirectories with the number of the entry as their name:
+		are subdirectories with the number of the entry as their name::
 
 			/sys/firmware/memmap/0
 			/sys/firmware/memmap/1
@@ -34,14 +34,16 @@ Description:
 
 		Each directory contains three files:
 
-		start	: The start address (as hexadecimal number with the
+		========  =====================================================
+		start	  The start address (as hexadecimal number with the
 			  '0x' prefix).
-		end	: The end address, inclusive (regardless whether the
+		end	  The end address, inclusive (regardless whether the
 			  firmware provides inclusive or exclusive ranges).
-		type	: Type of the entry as string. See below for a list of
+		type	  Type of the entry as string. See below for a list of
 			  valid types.
+		========  =====================================================
 
-		So, for example:
+		So, for example::
 
 			/sys/firmware/memmap/0/start
 			/sys/firmware/memmap/0/end
@@ -57,9 +59,8 @@ Description:
 		  - reserved
 
 		Following shell snippet can be used to display that memory
-		map in a human-readable format:
+		map in a human-readable format::
 
-		-------------------- 8< ----------------------------------------
 		  #!/bin/bash
 		  cd /sys/firmware/memmap
 		  for dir in * ; do
@@ -68,4 +69,3 @@ Description:
 		      type=$(cat $dir/type)
 		      printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type"
 		  done
-		-------------------- >8 ----------------------------------------
diff --git a/Documentation/ABI/testing/sysfs-fs-ext4 b/Documentation/ABI/testing/sysfs-fs-ext4
index 78604db56279..99e3d92f8299 100644
--- a/Documentation/ABI/testing/sysfs-fs-ext4
+++ b/Documentation/ABI/testing/sysfs-fs-ext4
@@ -45,8 +45,8 @@ Description:
 		parameter will have their blocks allocated out of a
 		block group specific preallocation pool, so that small
 		files are packed closely together.  Each large file
-		 will have its blocks allocated out of its own unique
-		 preallocation pool.
+		will have its blocks allocated out of its own unique
+		preallocation pool.
 
 What:		/sys/fs/ext4/<disk>/inode_readahead_blks
 Date:		March 2008
diff --git a/Documentation/ABI/testing/sysfs-hypervisor-xen b/Documentation/ABI/testing/sysfs-hypervisor-xen
index 53b7b2ea7515..4dbe0c49b393 100644
--- a/Documentation/ABI/testing/sysfs-hypervisor-xen
+++ b/Documentation/ABI/testing/sysfs-hypervisor-xen
@@ -15,14 +15,17 @@ KernelVersion:	4.3
 Contact:	Boris Ostrovsky <boris.ostrovsky@oracle.com>
 Description:	If running under Xen:
 		Describes mode that Xen's performance-monitoring unit (PMU)
-		uses. Accepted values are
-			"off"  -- PMU is disabled
-			"self" -- The guest can profile itself
-			"hv"   -- The guest can profile itself and, if it is
+		uses. Accepted values are:
+
+			======    ============================================
+			"off"     PMU is disabled
+			"self"    The guest can profile itself
+			"hv"      The guest can profile itself and, if it is
 				  privileged (e.g. dom0), the hypervisor
-			"all" --  The guest can profile itself, the hypervisor
+			"all"     The guest can profile itself, the hypervisor
 				  and all other guests. Only available to
 				  privileged guests.
+			======    ============================================
 
 What:           /sys/hypervisor/pmu/pmu_features
 Date:           August 2015
diff --git a/Documentation/ABI/testing/sysfs-kernel-boot_params b/Documentation/ABI/testing/sysfs-kernel-boot_params
index eca38ce2852d..7f9bda453c4d 100644
--- a/Documentation/ABI/testing/sysfs-kernel-boot_params
+++ b/Documentation/ABI/testing/sysfs-kernel-boot_params
@@ -23,16 +23,17 @@ Description:	The /sys/kernel/boot_params directory contains two
 		representation of setup_data type. "data" file is the binary
 		representation of setup_data payload.
 
-		The whole boot_params directory structure is like below:
-		/sys/kernel/boot_params
-		|__ data
-		|__ setup_data
-		|   |__ 0
-		|   |   |__ data
-		|   |   |__ type
-		|   |__ 1
-		|       |__ data
-		|       |__ type
-		|__ version
+		The whole boot_params directory structure is like below::
+
+		  /sys/kernel/boot_params
+		  |__ data
+		  |__ setup_data
+		  |   |__ 0
+		  |   |   |__ data
+		  |   |   |__ type
+		  |   |__ 1
+		  |       |__ data
+		  |       |__ type
+		  |__ version
 
 Users:		Kexec
diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-hugepages b/Documentation/ABI/testing/sysfs-kernel-mm-hugepages
index fdaa2162fae1..294387e2c7fb 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-hugepages
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-hugepages
@@ -7,9 +7,11 @@ Description:
 		of the hugepages supported by the kernel/CPU combination.
 
 		Under these directories are a number of files:
-			nr_hugepages
-			nr_overcommit_hugepages
-			free_hugepages
-			surplus_hugepages
-			resv_hugepages
+
+			- nr_hugepages
+			- nr_overcommit_hugepages
+			- free_hugepages
+			- surplus_hugepages
+			- resv_hugepages
+
 		See Documentation/admin-guide/mm/hugetlbpage.rst for details.
diff --git a/Documentation/ABI/testing/sysfs-platform-asus-laptop b/Documentation/ABI/testing/sysfs-platform-asus-laptop
index 8b0e8205a6a2..c78d358dbdbe 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-laptop
+++ b/Documentation/ABI/testing/sysfs-platform-asus-laptop
@@ -4,13 +4,16 @@ KernelVersion:	2.6.20
 Contact:	"Corentin Chary" <corentincj@iksaif.net>
 Description:
 		This file allows display switching. The value
-		is composed by 4 bits and defined as follow:
-		4321
-		|||`- LCD
-		||`-- CRT
-		|`--- TV
-		`---- DVI
-		Ex: - 0 (0000b) means no display
+		is composed by 4 bits and defined as follow::
+
+		  4321
+		  |||`- LCD
+		  ||`-- CRT
+		  |`--- TV
+		  `---- DVI
+
+		Ex:
+		    - 0 (0000b) means no display
 		    - 3 (0011b) CRT+LCD.
 
 What:		/sys/devices/platform/asus_laptop/gps
@@ -28,8 +31,10 @@ Contact:	"Corentin Chary" <corentincj@iksaif.net>
 Description:
 		Some models like the W1N have a LED display that can be
 		used to display several items of information.
-		To control the LED display, use the following :
+		To control the LED display, use the following::
+
 		    echo 0x0T000DDD > /sys/devices/platform/asus_laptop/
+
 		where T control the 3 letters display, and DDD the 3 digits display.
 		The DDD table can be found in Documentation/admin-guide/laptops/asus-laptop.rst
 
diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
index 87ae5cc983bf..b71014d9e1b1 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -5,6 +5,7 @@ Contact:	"Corentin Chary" <corentincj@iksaif.net>
 Description:
 		Change CPU clock configuration (write-only).
 		There are three available clock configuration:
+
 		    * 0 -> Super Performance Mode
 		    * 1 -> High Performance Mode
 		    * 2 -> Power Saving Mode
diff --git a/Documentation/ABI/testing/sysfs-platform-at91 b/Documentation/ABI/testing/sysfs-platform-at91
index 4cc6a865ae66..b146be74b8e0 100644
--- a/Documentation/ABI/testing/sysfs-platform-at91
+++ b/Documentation/ABI/testing/sysfs-platform-at91
@@ -18,8 +18,10 @@ Description:
 		In order to use an extended can_id add the
 		CAN_EFF_FLAG (0x80000000U) to the can_id. Example:
 
-		- standard id 0x7ff:
-		echo 0x7ff      > /sys/class/net/can0/mb0_id
+		- standard id 0x7ff::
 
-		- extended id 0x1fffffff:
-		echo 0x9fffffff > /sys/class/net/can0/mb0_id
+		    echo 0x7ff      > /sys/class/net/can0/mb0_id
+
+		- extended id 0x1fffffff::
+
+		    echo 0x9fffffff > /sys/class/net/can0/mb0_id
diff --git a/Documentation/ABI/testing/sysfs-platform-eeepc-laptop b/Documentation/ABI/testing/sysfs-platform-eeepc-laptop
index 5b026c69587a..70dbe0733cf6 100644
--- a/Documentation/ABI/testing/sysfs-platform-eeepc-laptop
+++ b/Documentation/ABI/testing/sysfs-platform-eeepc-laptop
@@ -4,9 +4,11 @@ KernelVersion:	2.6.26
 Contact:	"Corentin Chary" <corentincj@iksaif.net>
 Description:
 		This file allows display switching.
+
 		- 1 = LCD
 		- 2 = CRT
 		- 3 = LCD+CRT
+
 		If you run X11, you should use xrandr instead.
 
 What:		/sys/devices/platform/eeepc/camera
@@ -30,16 +32,20 @@ Contact:	"Corentin Chary" <corentincj@iksaif.net>
 Description:
 		Change CPU clock configuration.
 		On the Eee PC 1000H there are three available clock configuration:
+
 		    * 0 -> Super Performance Mode
 		    * 1 -> High Performance Mode
 		    * 2 -> Power Saving Mode
+
 		On Eee PC 701 there is only 2 available clock configurations.
 		Available configuration are listed in available_cpufv file.
 		Reading this file will show the raw hexadecimal value which
-		is defined as follow:
-		| 8 bit | 8 bit |
-		    |       `---- Current mode
-		    `------------ Availables modes
+		is defined as follow::
+
+		  | 8 bit | 8 bit |
+		      |       `---- Current mode
+		      `------------ Availables modes
+
 		For example, 0x301 means: mode 1 selected, 3 available modes.
 
 What:		/sys/devices/platform/eeepc/available_cpufv
diff --git a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
index 1b31be3f996a..fd2ac02bc5bd 100644
--- a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
+++ b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
@@ -12,6 +12,7 @@ Contact:	"Maxim Mikityanskiy <maxtram95@gmail.com>"
 Description:
 		Change fan mode
 		There are four available modes:
+
 			* 0 -> Super Silent Mode
 			* 1 -> Standard Mode
 			* 2 -> Dust Cleaning
@@ -32,9 +33,11 @@ KernelVersion:	4.18
 Contact:	"Oleg Keri <ezhi99@gmail.com>"
 Description:
 		Control fn-lock mode.
+
 			* 1 -> Switched On
 			* 0 -> Switched Off
 
-		For example:
-		# echo "0" >	\
-		/sys/bus/pci/devices/0000:00:1f.0/PNP0C09:00/VPC2004:00/fn_lock
+		For example::
+
+		  # echo "0" >	\
+		  /sys/bus/pci/devices/0000:00:1f.0/PNP0C09:00/VPC2004:00/fn_lock
diff --git a/Documentation/ABI/testing/sysfs-platform-intel-wmi-thunderbolt b/Documentation/ABI/testing/sysfs-platform-intel-wmi-thunderbolt
index 8af65059d519..e19144fd5d86 100644
--- a/Documentation/ABI/testing/sysfs-platform-intel-wmi-thunderbolt
+++ b/Documentation/ABI/testing/sysfs-platform-intel-wmi-thunderbolt
@@ -7,5 +7,6 @@ Description:
 		Thunderbolt controllers to turn on or off when no
 		devices are connected (write-only)
 		There are two available states:
+
 		    * 0 -> Force power disabled
 		    * 1 -> Force power enabled
diff --git a/Documentation/ABI/testing/sysfs-platform-sst-atom b/Documentation/ABI/testing/sysfs-platform-sst-atom
index 0d07c0395660..d5f6e21f0e42 100644
--- a/Documentation/ABI/testing/sysfs-platform-sst-atom
+++ b/Documentation/ABI/testing/sysfs-platform-sst-atom
@@ -5,13 +5,22 @@ Contact:	"Sebastien Guiriec" <sebastien.guiriec@intel.com>
 Description:
 		LPE Firmware version for SST driver on all atom
 		plaforms (BYT/CHT/Merrifield/BSW).
-		If the FW has never been loaded it will display:
+		If the FW has never been loaded it will display::
+
 			"FW not yet loaded"
-		If FW has been loaded it will display:
+
+		If FW has been loaded it will display::
+
 			"v01.aa.bb.cc"
+
 		aa: Major version is reflecting SoC version:
+
+			=== =============
 			0d: BYT FW
 			0b: BSW FW
 			07: Merrifield FW
+			=== =============
+
 		bb: Minor version
+
 		cc: Build version
diff --git a/Documentation/ABI/testing/sysfs-platform-usbip-vudc b/Documentation/ABI/testing/sysfs-platform-usbip-vudc
index 81fcfb454913..53622d3ba27c 100644
--- a/Documentation/ABI/testing/sysfs-platform-usbip-vudc
+++ b/Documentation/ABI/testing/sysfs-platform-usbip-vudc
@@ -16,10 +16,13 @@ Contact:	Krzysztof Opasiak <k.opasiak@samsung.com>
 Description:
 		Current status of the device.
 		Allowed values:
-		1 - Device is available and can be exported
-		2 - Device is currently exported
-		3 - Fatal error occurred during communication
-		  with peer
+
+		==  ==========================================
+		1   Device is available and can be exported
+		2   Device is currently exported
+		3   Fatal error occurred during communication
+		    with peer
+		==  ==========================================
 
 What:		/sys/devices/platform/usbip-vudc.%d/usbip_sockfd
 Date:		April 2016
diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
index a17f817a9309..2363ad810ddb 100644
--- a/Documentation/ABI/testing/sysfs-ptp
+++ b/Documentation/ABI/testing/sysfs-ptp
@@ -69,7 +69,7 @@ Description:
 		pin offered by the PTP hardware clock. The file name
 		is the hardware dependent pin name. Reading from this
 		file produces two numbers, the assigned function (see
-		the PTP_PF_ enumeration values in linux/ptp_clock.h)
+		the `PTP_PF_` enumeration values in linux/ptp_clock.h)
 		and the channel number. The function and channel
 		assignment may be changed by two writing numbers into
 		the file.
diff --git a/Documentation/ABI/testing/sysfs-uevent b/Documentation/ABI/testing/sysfs-uevent
index aa39f8d7bcdf..d0893dad3f38 100644
--- a/Documentation/ABI/testing/sysfs-uevent
+++ b/Documentation/ABI/testing/sysfs-uevent
@@ -19,7 +19,8 @@ Description:
                 a transaction identifier so it's possible to use the same UUID
                 value for one or more synthetic uevents in which case we
                 logically group these uevents together for any userspace
-                listeners. The UUID value appears in uevent as
+                listeners. The UUID value appears in uevent as:
+
                 "SYNTH_UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" environment
                 variable.
 
@@ -30,18 +31,19 @@ Description:
                 It's possible to define zero or more pairs - each pair is then
                 delimited by a space character ' '. Each pair appears in
                 synthetic uevent as "SYNTH_ARG_KEY=VALUE". That means the KEY
-                name gains "SYNTH_ARG_" prefix to avoid possible collisions
+                name gains `SYNTH_ARG_` prefix to avoid possible collisions
                 with existing variables.
 
-                Example of valid sequence written to the uevent file:
+                Example of valid sequence written to the uevent file::
 
                     add fe4d7c9d-b8c6-4a70-9ef1-3d8a58d18eed A=1 B=abc
 
-                This generates synthetic uevent including these variables:
+                This generates synthetic uevent including these variables::
 
                     ACTION=add
                     SYNTH_ARG_A=1
                     SYNTH_ARG_B=abc
                     SYNTH_UUID=fe4d7c9d-b8c6-4a70-9ef1-3d8a58d18eed
+
 Users:
                 udev, userspace tools generating synthetic uevents
diff --git a/Documentation/admin-guide/abi-testing.rst b/Documentation/admin-guide/abi-testing.rst
index 5c886fc50b9e..b205b16a72d0 100644
--- a/Documentation/admin-guide/abi-testing.rst
+++ b/Documentation/admin-guide/abi-testing.rst
@@ -17,3 +17,4 @@ name to the description of these interfaces, so that the kernel
 developers can easily notify them if any changes occur.
 
 .. kernel-abi:: $srctree/Documentation/ABI/testing
+   :rst:
-- 
2.21.0

